//
//  ContrivedUsageExample.swift
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

class ContrivedUsageExample {

    // Problem: How do we keep `StringWrapper` and `AnotherStringWrapper` instances together in a collection?

}

// MARK: - Wrong approach #1

extension ContrivedUsageExample {

    // ERROR: Heterogeneous collection literal could only be inferred to '[Any]'; add explicit type annotation if this is intentional

//    static let collection = [
//        StringWrapper(value: "foo"),
//        AnotherStringWrapper(value: "bar")
//    ]

}

// MARK: - Wrong approach #2

extension ContrivedUsageExample {

    // ERROR: Protocol 'WrapperProtocol' can only be used as a generic constraint because it has Self or associated type requirements

//    static let collection: [WrapperProtocol] = [
//        StringWrapper(value: "foo"),
//        AnotherStringWrapper(value: "bar")
//    ]

}

// MARK: - Correct approach (immutable)

extension ContrivedUsageExample {

    static let collection: [AnyWrapper<String>] = [
        AnyWrapper(StringWrapper(value: "foo")),
        AnyWrapper(AnotherStringWrapper(value: "bar"))
    ]
}

// MARK: - Correct approach (mutable)

extension ContrivedUsageExample {

    static let mutableCollection: [AnyMutableWrapper<String>] = [
        AnyMutableWrapper(MutableStringWrapper(value: "baz")),
        AnyMutableWrapper(AnotherMutableStringWrapper(value: "qux"))
    ]
}
