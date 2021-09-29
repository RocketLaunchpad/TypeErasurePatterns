//
//  AnyWrapper.swift
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

struct AnyWrapper<ValueType>: WrapperProtocol {

    private let _getValue: () -> ValueType

    init<T>(_ wrapper: T) where T: WrapperProtocol, T.ValueType == ValueType {
        _getValue = {
            return wrapper.value
        }
    }

    var value: ValueType {
        get {
            _getValue()
        }
    }
}

// We are unable to use this pattern for mutable protocols.

/*
struct AnyMutableWrapper<ValueType>: MutableWrapperProtocol where ValueType: Equatable {

    private let _getValue: () -> ValueType

    private let _setValue: (ValueType) -> Void

    private let _valueIsEqualTo: (ValueType) -> Bool

    init<T>(_ wrapper: T) where T: MutableWrapperProtocol, T.ValueType == ValueType {
        _getValue = {
            return wrapper.value
        }

        _setValue = {
            // ERROR: Cannot assign to property: 'wrapper' is a 'let' constant
            wrapper.value = $0
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
*/
