//
//  AnyWrapper.swift
//  TypeErasurePatterns
//
//  Created by Paul Calnan on 9/29/21.
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
