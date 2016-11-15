//
//  JSONValue.swift
//  Monolith
//
//  Created by Hoon H. on 10/20/14.
//
//

import Foundation

///	Explicitly typed representation.
public enum JSONValue : Equatable {
    case object(JSONObject)
    case array(JSONArray)
    case string(String)
    case number(JSONNumber)
    case boolean(Bool)
    /// JSON Null is treated as an actual value of type `()`.
    /// So it's different with `Optional.none`.
    case null(())
}

public typealias JSONObject = [Swift.String:JSONValue]
public typealias JSONArray  = [JSONValue]

///	Arbitrary precision number container.
public enum JSONNumber : Equatable {
    case int64(Int64)
    case float(Double)
//		case Decimal(NSDecimalNumber)		//	Very large sized decimal number.
//		case Arbitrary(expression:String)	//	Arbitrary sized integer/real number expression.

    public var int64: Int64? {
        get {
            switch self {
            case let .int64(state): return state
            default:                return nil
            }
        }
    }
    public var float: Double? {
        get {
            switch self {
            case let .float(state): return state
            default:                return nil
            }
        }
    }
}

public extension JSONValue {
    public var object: JSONObject? {
        get {
            switch self {
            case let .object(state):    return	state
            default:					return	nil
            }
        }
    }
    public var array: [JSONValue]? {
        get {
            switch self {
            case let .array(state):		return	state
            default:					return	nil
            }
        }
    }
    public var string: Swift.String? {
        get {
            switch self {
            case let .string(state):	return	state
            default:					return	nil
            }
        }
    }
    public var number: JSONNumber? {
        get {
            switch self {
            case let .number(state):	return	state
            default:					return	nil
            }
        }
    }
    public var boolean: Bool? {
        get {
            switch self {
            case let .boolean(state):	return	state
            default:					return	nil
            }
        }
    }
    /// Checks current value is actually a *JSON Null*.
    /// JSON Null is treated as an actual value of type `()`.
    /// Don't be confused. `()` for JSON `null`, and
    /// `nil` for any other type values.
    public var null: ()? {
        get {
            switch self {
            case .null: return	()
            default:	return	nil
            }
        }
    }
}

///	MARK:
///	MARK:	Literals
///	MARK:
extension JSONValue: ExpressibleByNilLiteral, ExpressibleByBooleanLiteral, ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral, ExpressibleByStringLiteral, ExpressibleByExtendedGraphemeClusterLiteral, ExpressibleByUnicodeScalarLiteral, ExpressibleByArrayLiteral, ExpressibleByDictionaryLiteral {
    public typealias Key     = Swift.String
    public typealias Value	 = JSONValue
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
        self = Value.number(JSONNumber.float(Float64(value)))
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
        var	o1 = [:] as [Key:Value]
        for (k,v) in elements {
            o1[k] = v
        }
        self = Value.object(o1)
    }
}








//
/////	MARK:
/////	MARK:	Collecion Support
/////	MARK:
//
/////	`JSONValue` is treated as an array when you enumerate on it.
/////	If underlying value is not an array, it will cause program crash.
/////
//extension RFC4627.Value : CollectionType {
//	public var startIndex:Int {
//		get {
//			precondition(array != nil)
//			return	array!.startIndex
//		}
//	}
//	public var endIndex:Int {
//		get {
//			precondition(array != nil)
//			return	array!.endIndex
//		}
//	}
//	public subscript(name:Swift.String) -> Value? {
//		get {
//			return	object?[name]
//		}
//	}
//	public subscript(index:Int) -> Value {
//		get {
//			return	array![index]
//		}
//	}
//	public func generate() -> IndexingGenerator<[Value]> {
//		precondition(array != nil, "Current `Value` does not contain an array.")
//		return	array!.generate()
//	}
//}
//


































































































































