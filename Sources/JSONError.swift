//
//  JSON.Error.swift
//  EoniJSON
//
//  Created by Hoon H. on 2016/06/05.
//  Copyright © 2016 Eonil. All rights reserved.
//

public struct JSONError: Error {
    public private(set) var message: String
    public init(_ message: String) {
        self.message = message
    }
}
