//
//  JSON.swift
//  EoniJSON
//
//  Created by Hoon H. on 10/21/14.
//
//

import Foundation

public struct JSON {
    public static func deserialize(_ data: Data) throws -> JSONValue {
        let o1 = try JSONSerialization.jsonObject(with: data, options: [])
        guard let o2 = o1 as? NSObject else { throw JSONError("Internal `NSJSONSerialization.JSONObjectWithData` returned non-`NSObject` object. Unacceptable. \(o1)") }
        let o3 = try Converter.convertFromOBJC(o2)
        return o3
    }
    public static func serialize(_ value: JSONValue) throws -> Data {
        return try serialize(value, allowFragment: false)
    }
    /// This does not allow serialisation of fragment. A JSON value must be one
    /// of object or array type. This limitation is due to limitation of `NSJSONSerialization` class.
    static func serialize(_ value: JSONValue, allowFragment: Bool) throws -> Data {
        assert(value.object != nil || value.array != nil)
        let o2:AnyObject = Converter.convertFromSwift(value)
        let d3:Data = try JSONSerialization.data(withJSONObject: o2, options: [.prettyPrinted])
        return  d3
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Privates
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/// Converts JSON tree between Objective-C and Swift representations.
private struct Converter {
    typealias Value = JSONValue

    /// Gets strongly typed JSON tree.
    ///
    /// This function assumes input fully convertible data.
    /// Throws any error in conversion.
    ///
    /// Objective-C `nil` is not supported as an input.
    /// Use `NSNull` which is standard way to represent `nil`
    /// in data-structures in Cocoa.
    static func convertFromOBJC(_ v1: NSObject) throws -> Value {
        func convertArray(_ v1:NSArray) throws -> Value {
            var a2 = [] as [Value]
            for m1 in v1 {
                /// Must be an OBJC type.
                guard let m1 = m1 as? NSObject else { throw JSONError("Non-OBJC type object (that is not convertible) discovered.") }
                let m2 = try convertFromOBJC(m1)
                a2.append(m2)
            }
            return Value.array(a2)
        }
        func convertObject(_ v1: NSDictionary) throws -> Value {
            var o2 = [:] as [String:Value]
            for p1 in v1 {
                guard let k1 = p1.key as? NSString as? String else { throw JSONError("") }
                guard let p2 = p1.value as? NSObject else { throw JSONError("") }
                let v2 = try convertFromOBJC(p2)
                o2[k1] = v2
            }
            return Value.object(o2)
        }

        if v1 is NSNull { return Value.null(Void()) }
        if let v2 = v1 as? NSNumber {
            /// `NSNumber` can be a `CFBoolean` exceptionally if it was created from a boolean value.
            if CFGetTypeID(v2) == CFBooleanGetTypeID() {
                let v3 = CFBooleanGetValue(v2)
                return Value.boolean(v3)
            }
            if CFNumberIsFloatType(v2) {
                return Value.number(JSONNumber.float64(v2.doubleValue))
            }
            else {
                return Value.number(JSONNumber.int64(v2.int64Value))
            }
        }
        if let v1 = v1 as? NSString as? String { return Value.string(v1) }
        if let v1 = v1 as? NSArray { return try convertArray(v1) }
        if let v1 = v1 as? NSDictionary { return try convertObject(v1) }
        throw JSONError("Unsupported type. Failed.")
    }
    static func convertFromSwift(_ v1: Value) -> NSObject {
        func convertArray(_ a1: [Value]) -> NSArray {
            let a2 = NSMutableArray()
            for m1 in a1 {
                let m2 = convertFromSwift(m1)
                a2.add(m2)
            }
            return a2
        }
        func convertObject(_ o1: [String: Value]) -> NSDictionary {
            let o2 = NSMutableDictionary()
            for (k1, v1) in o1 {
                let k2 = k1 as NSString
                let v2 = convertFromSwift(v1)
                o2.setObject(v2, forKey: k2)
            }
            return o2
        }

        switch v1 {
        case Value.null():                              return NSNull()
        case Value.boolean(let boolValue):              return NSNumber(value: boolValue as Bool)
        case Value.number(let numberValue):
            switch numberValue {
            case JSONNumber.int64(let int64Value):      return NSNumber(value: int64Value as Int64)
            case JSONNumber.float64(let floatValue):    return NSNumber(value: floatValue as Double)
            }
        case Value.string(let stringValue):             return stringValue as NSString
        case Value.array(let arrayValue):               return convertArray(arrayValue)
        case Value.object(let objectValue):             return convertObject(objectValue)
        }
    }
}
















