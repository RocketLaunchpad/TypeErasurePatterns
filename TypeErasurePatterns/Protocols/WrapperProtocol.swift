//
//  WrapperProtocol.swift
//  TypeErasurePatterns
//
//  Created by Paul Calnan on 9/29/21.
//

import Foundation

protocol WrapperProtocol {

    associatedtype ValueType

    var value: ValueType { get }
}
