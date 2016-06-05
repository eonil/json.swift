//
//  JSON.Serialization.swift
//  EonilJSON
//
//  Created by Hoon H. on 2016/06/05.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation.NSData
import Foundation.NSJSONSerialization

public extension JSON {
    public static func deserialize(data:NSData) throws -> JSON.Value {
        let	o2:AnyObject = try NSJSONSerialization.JSONObjectWithData(data, options: [])
        let	o3 = try Converter.convertFromOBJ(o2)
        return o3
    }

    public static func serialize(value:JSON.Value) throws -> NSData {
        return try serialize(value, allowFragment: false)
    }
    ///	This does not allow serialisation of fragment. A JSON value must be one
    ///	of object or array type. This limitation is due to limitation of `NSJSONSerialization` class.
    static func serialize(value:JSON.Value, allowFragment:Bool) throws -> NSData {
        assert(value.object != nil || value.array != nil)
        let	o2:AnyObject	=	Converter.convertFromSwift(value)
        //		let	d3:NSData?		=	NSJSONSerialization.dataWithJSONObject(o2, options: (NSJSONWritingOptions.allZeros) | NSJSONWritingOptions.PrettyPrinted), error: &e1)
        let	d3:NSData		=	try NSJSONSerialization.dataWithJSONObject(o2, options: [.PrettyPrinted])
        return d3
    }
}


















////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Privates
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///	Converts JSON tree between Objective-C and Swift representations.
private struct Converter {
    typealias Value = JSON.Value

    /// Gets strongly typed JSON tree.
    ///
    /// This function assumes input fully convertible data.
    /// Throws any error in conversion.
    ///
    ///	Objective-C `nil` is not supported as an input.
    ///	Use `NSNull` which is standard way to represent `nil`
    ///	in data-structures in Cocoa.
    static func convertFromOBJ(v1: AnyObject) throws -> Value {
        assert(v1 is NSObject)
        func convertArray(v1:NSArray) throws -> Value {
            var	a2 = [] as [Value]
            for m1 in v1 {
                ///	Must be an OBJC type.
                guard let m1 = m1 as? NSObject else { throw JSON.Error("Non-OBJC type object (that is not convertible) discovered.") }
                let	m2 = try convertFromOBJ(m1)
                a2.append(m2)
            }
            return	Value.Array(a2)
        }
        func convertObject(v1:NSDictionary) throws -> Value {
            var	o2	=	[:] as [String:Value]
            for p1 in v1 {
                guard let k1 = p1.key as? NSString as? String else { throw JSON.Error("") }
                let v2 = try convertFromOBJ(p1.value)
                o2[k1] = v2
            }
            return	Value.Object(o2)
        }

        if v1 is NSNull { return Value.Null(()) }
        if let v2 = v1 as? NSNumber {
            ///	`NSNumber` can be a `CFBoolean` exceptionally if it was created from a boolean value.
            if CFGetTypeID(v2) == CFBooleanGetTypeID() {
                let	v3	=	CFBooleanGetValue(v2)
                return	Value.Boolean(v3)
            }
            if CFNumberIsFloatType(v2) {
                return	Value.Number(JSON.Number.Float(v2.doubleValue))
            }
            else {
                return Value.Number(JSON.Number.Integer(v2.longLongValue))
            }
        }
        if let v1 = v1 as? NSString as? String { return Value.String(v1) }
        if let v1 = v1 as? NSArray { return try convertArray(v1) }
        if let v1 = v1 as? NSDictionary { return try convertObject(v1) }
        throw JSON.Error("Unsupported type. Failed.")
    }
    static func convertFromSwift(v1:Value) -> AnyObject {
        func convertArray(a1:[Value]) -> NSArray {
            let	a2	=	NSMutableArray()
            for m1 in v1.array! {
                let	m2 = convertFromSwift(m1)
                a2.addObject(m2)
            }
            return	a2
        }
        func convertObject(o1:[String:Value]) -> NSDictionary {
            let	o2	=	NSMutableDictionary()
            for (k1, v1) in o1 {
                let	k2 = k1 as NSString
                let	v2 = convertFromSwift(v1)
                o2.setObject(v2, forKey: k2)
            }
            return	o2
        }

        switch v1 {
        case Value.Null():                          return NSNull()
        case Value.Boolean(let boolValue):          return NSNumber(bool: boolValue)
        case Value.Number(let numberValue):
            switch numberValue {
            case JSON.Number.Integer(let integerValue): return NSNumber(longLong: integerValue)
            case JSON.Number.Float(let floatValue):     return NSNumber(double: floatValue)
            }
        case Value.String(let stringValue):         return stringValue as NSString
        case Value.Array(let arrayValue):           return convertArray(arrayValue)
        case Value.Object(let objectValue):         return convertObject(objectValue)
        }
    }
}
















