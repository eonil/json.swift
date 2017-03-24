//
//  JSONValue.swift
//  EoniJSON
//
//  Created by Hoon H. on 10/20/14.
//
//

import Foundation

public enum JSONValue: Equatable {
    case object(JSONObject)
    case array(JSONArray)
    case string(JSONString)
    case number(JSONNumber)
    case boolean(JSONBoolean)
    ///
    /// Represents `null` in JSON.
    ///
    /// JSON Null is treated as an actual value of type `Void`.
    /// So it's different with `Optional.none`.
    ///
    case null(JSONNull)
}

public typealias JSONObject     =   [JSONString: JSONValue]
public typealias JSONArray      =   [JSONValue]
public typealias JSONString     =   String
public typealias JSONBoolean    =   Bool
public typealias JSONNull       =   Void

///
/// Represents a JSON number.
///
/// There's no clearly typed non-OBJC numeric type for JSON Numbers.
///
public enum JSONNumber: Equatable {
    case int64(Int64)
    case float64(Float64)
//  case Arbitrary(expression:String) // Arbitrary sized integer/real number expression.

    public var int64: Int64? {
        if case let .int64(v) = self { return v }
        return nil
    }
    public var float64: Float64? {
        if case let .float64(v) = self { return v }
        return nil
    }
}

public extension JSONValue {
    public var object: JSONObject? {
        if case let .object(v) = self { return v }
        return nil
    }
    public var array: JSONArray? {
        if case let .array(v) = self { return v }
        return nil
    }
    public var string: JSONString? {
        if case let .string(v) = self { return v }
        return nil
    }
    public var number: JSONNumber? {
        if case let .number(v) = self { return v }
        return nil
    }
    public var boolean: JSONBoolean? {
        if case let .boolean(v) = self { return v }
        return nil
    }
    /// Checks current value is actually a *JSON Null*.
    /// JSON Null is treated as an actual value of type `Void`.
    /// Don't be confused. `Void()` for JSON `null`, and
    /// `nil` for any other type values.
    public var null: Void? {
        get {
            switch self {
            case .null: return Void()
            default:    return nil
            }
        }
    }
}



/*

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
extension JSONValue: ExpressibleByNilLiteral, ExpressibleByBooleanLiteral, ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral, ExpressibleByStringLiteral, ExpressibleByExtendedGraphemeClusterLiteral, ExpressibleByUnicodeScalarLiteral, ExpressibleByArrayLiteral, ExpressibleByDictionaryLiteral {
    public typealias Key     = JSONString
    public typealias Value   = JSONValue
    public typealias Element = JSONValue

    public init(nilLiteral: ()) {
        self = Value.null(())
    }
    public init(booleanLiteral value: BooleanLiteralType) {
        self = Value.boolean(value)
    }
    public init(integerLiteral value: IntegerLiteralType) {
        self = Value.number(JSONNumber.int64(Int64(value)))
    }
    public init(floatLiteral value: FloatLiteralType) {
        self = Value.number(JSONNumber.float64(Float64(value)))
    }
    public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterType) {
        self.init(stringLiteral: value)
    }
    public init(stringLiteral value: StringLiteralType) {
        self = Value.string(value)
    }
    public init(unicodeScalarLiteral value: UnicodeScalarType) {
        self.init(stringLiteral: value)
    }
    public init(arrayLiteral elements: Element...) {
        self = Value.array(elements)
    }
    public init(dictionaryLiteral elements: (Key, Value)...) {
        var o1 = [:] as [Key:Value]
        for (k,v) in elements {
            o1[k] = v
        }
        self = Value.object(o1)
    }
}

*/
