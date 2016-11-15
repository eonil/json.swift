//
//  JSON.Error.swift
//  EonilIETF
//
//  Created by Hoon H. on 2016/06/05.
//  Copyright © 2016 Eonil. All rights reserved.
//

public struct JSONError: Error {
    var message: String
    init(_ message: String){
        self.message = message
    }
}
