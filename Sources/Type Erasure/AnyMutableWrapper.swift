//
//  AnyMutableWrapper.swift
//  TypeErasurePatterns
//
//  Copyright (c) 2021 Rocket Insights, Inc.
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
//

import Foundation

// MARK: - The closure approach will not work

struct WrongWayToWriteAnyMutableWrapper<ValueType>: MutableWrapperProtocol where ValueType: Equatable {

    private let _getValue: () -> ValueType

    private let _setValue: (ValueType) -> Void

    init<T>(_ wrapper: T) where T: MutableWrapperProtocol, T.ValueType == ValueType {
        _getValue = {
            return wrapper.value
        }

        _setValue = { value in
            // ERROR: Cannot assign to property: 'wrapper' is a 'let' constant
            // wrapper.value = value
        }
    }

    var value: ValueType {
        get {
            _getValue()
        }

        set {
            _setValue(newValue)
        }
    }
}

// MARK: - The "Right Way" to do mutable type erasure

// Part 1: Private abstract base class
// -----------------------------------
//
// We use this for "interface inheritance." Specifically, we are generic over `ValueType` and provide a read-write
// `value` property of that generic type (i.e, `var value: ValueType`).
//
// This looks like the interface we want from our type-erased class. There's no implementation though; it's entirely
// abstract.
//
// It defines an interface and provides no implementation. It's kind of like a protocol with generics, if such a
// thing existed in Swift. Unfortunately, we need to have all of these `fatalErrors()` to ensure that it is properly
// abstract.
//
private class _AnyMutableWrapperBase<ValueType>: MutableWrapperProtocol {

    init() {
        guard type(of: self) != _AnyMutableWrapperBase.self else {
            fatalError("Cannot create an instance of _AnyMutableWrapperBase. Create a subclass instead.")
        }
    }

    var value: ValueType {
        get {
            fatalError("Must override")
        }

        set {
            fatalError("Must override")
        }
    }
}

// Part 2: Private box class
// -------------------------
//
// This boxes a `ConcreteMutableWrapper` instance (which implements `MutableWrapperProtocol`). We are generic over
// `ConcreteMutableWrapper`, the boxed type.
//
// We inherit from the abstract base class, specialized for `ConcreteMutableWrapper.ValueType`. This gives us the
// correct type on `value`, namely `ConcreteMutableWrapper.ValueType`.
//
// Let's use some real types to understand better.
//
// Consider a struct:
//
//     struct MutableStringWrapper: MutableWrapperProtocol {
//         var property: String
//     }
//
// Now, if we were to wrap that in `_AnyMutableWrapperBox`:
//
//     let value = MutableStringWrapper(property: "foo")
//     let box = _AnyMutableWrapperBox(value)
//
// Our `box` variable is of type `_AnyMutableWrapperBox<MutableStringWrapper>` _and_ `_AnyMutableWrapperBase<String>`.
// Another way of writing the code above is:
//
//     let value = MutableStringType(property: "foo")
//     let box: _AnyMutableTypeBase<String> = _AnyMutableTypeBox(value)
//
// Keep that last point in mind when we get to Part 3.
private final class _AnyMutableWrapperBox<ConcreteMutableWrapper: MutableWrapperProtocol>: _AnyMutableWrapperBase<ConcreteMutableWrapper.ValueType> {

    // Store the boxed object in a var to allow us to mutate it.
    private var boxed: ConcreteMutableWrapper

    init(_ value: ConcreteMutableWrapper) {
        self.boxed = value
    }

    // This trampolines to and from the boxed value.
    override var value: ConcreteMutableWrapper.ValueType {
        get {
            return boxed.value
        }

        set {
            boxed.value = newValue
        }
    }
}

// Part 3: The public, type-erased wrapper
// ---------------------------------------
//
final class AnyMutableWrapper<ValueType>: MutableWrapperProtocol {

    // The type of box is the abstract base class...
    private let box: _AnyMutableWrapperBase<ValueType>

    init<ConcreteMutableWrapper>(_ value: ConcreteMutableWrapper)
    where ConcreteMutableWrapper: MutableWrapperProtocol, ConcreteMutableWrapper.ValueType == ValueType {
        // ...but we assign it a value using the box class.
        box = _AnyMutableWrapperBox(value)
    }

    // This trampolines to and from the box.
    var value: ValueType {
        get {
            return box.value
        }

        set {
            box.value = newValue
        }
    }
}
