//
//  JSONValue.swift
//  EoniJSON
//
//  Created by Hoon H. on 10/20/14.
//
//

import Foundation

///
/// Represents a JSON AST.
///
/// For now, I am reconstructing AST from parsed output
/// of `JSONSerialization`.
///
/// - Note:
///     RFC7159 defines only about forms, and nothing
///     about their semantics.
///     Abstraction conforms JavaScript primitive semantics
///     closely as much as possible. Concept of boolean-type
///     is created in AST level to follow JavaScript primitive
///     semantics. At CST level, there're only `false` and 
///     `true` literals,
///     and no concept of boolean-type.
///
/// - SeeAlso: https://tools.ietf.org/html/rfc7159
/// - SeeAlso: https://developer.mozilla.org/en-US/docs/Glossary/Primitive
///
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
    /// Treating this as `Void()` make logics more clear.
    /// See `JSONValue.null` computed property.
    ///
    case null(JSONNull)
}

public typealias JSONObject     =   [JSONString: JSONValue]
public typealias JSONArray      =   [JSONValue]
public typealias JSONString     =   String
///
/// Invented concept of boolean-type in AST level.
///
public typealias JSONBoolean    =   Bool
public typealias JSONNull       =   Void

///
/// Represents a JSON number.
///
/// There's nothing like JSON Number in Swift.
/// `NSNumber` is very close, but it is OBJC, 
/// and I don't want extra dependency to OBJC.
/// `Decimal` is very close, but it's very
/// inefficient.
///
/// Also, this MUST be an opaque type because
/// JSON Number DOES NOT support irregular 
/// `Float64` state like `nan`. This type 
/// contains only valid state for JSON Value
/// by limiting acceptable state range.
///
/// JSON Number in RFC7159 is an unlimited,
/// arbitrary-length decimal, but this 
/// implementation support only up to IEEE-754 
/// double precision level numbers because this
/// follows JavaScript semantics.
///
/// - SeeAlso: https://tools.ietf.org/html/rfc7159#section-6
///
public struct JSONNumber: Equatable {
    internal let storage: Storage
    internal enum Storage {
        case int64(Int64)
        case float64(Float64)
//      case decimal(Decimal)
//      case Arbitrary(expression:String) // Arbitrary sized integer/real number expression.

        var int64: Int64? {
            if case let .int64(v) = self { return v }
            return nil
        }
        var float64: Float64? {
            if case let .float64(v) = self { return v }
            return nil
        }
    }

    public init(_ v: Int64) {
        storage = .int64(v)
    }
    ///
    /// Only values that are convertible into
    /// JSON Number accepted. Otherwise, this
    /// throws an error.
    ///
    public init(_ v: Float64) throws {
        guard v.isZero || v.isNormal else { throw JSONError("Value `\(v)` is not a zero or normal number and unacceptable.") }
        storage = .float64(v)
    }
    public var int64: Int64? {
        return storage.int64
    }
    public var float64: Float64? {
        return storage.float64
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
    ///
    /// Checks current value is actually a *JSON Null*.
    /// JSON Null is treated as an actual instance of type `Void`.
    /// 
    /// - Returns:
    ///     `Void()` for JSON `null`.
    ///     `nil` for any other type values.
    ///
    public var null: Void? {
        if case let .null(v) = self { return v }
        return nil
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
