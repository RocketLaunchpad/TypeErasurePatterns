//
//  ContrivedUsageExample.swift
//  TypeErasurePatterns
//
//  Created by Paul Calnan on 9/29/21.
//

import Foundation

class ContrivedUsageExample {

    let collection: [AnyWrapper<String>]

    init() {
        collection = [
            AnyWrapper(StringWrapper(value: "foo")),
            AnyWrapper(StringWrapper(value: "bar")),
            AnyWrapper(StringWrapper(value: "baz"))
        ]
    }
}
