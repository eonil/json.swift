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
    case Object(JSONObject)
    case Array(JSONArray)
    case String(Swift.String)
    case Number(JSONNumber)
    case Boolean(Bool)
    /// JSON Null is treated as an actual value of type `()`.
    /// So it's different with `Optional.None`.
    case Null(())
}

public typealias JSONObject = [Swift.String:JSONValue]
public typealias JSONArray  = [JSONValue]

///	Arbitrary precision number container.
public enum JSONNumber : Equatable {
    case Integer(Int64)
    case Float(Double)
    //		case Decimal(NSDecimalNumber)		//	Very large sized decimal number.
    //		case Arbitrary(expression:String)	//	Arbitrary sized integer/real number expression.

    public var integer: Int64? {
        get {
            switch self {
            case let .Integer(state):	return	state
            default:					return	nil
            }
        }
    }
    public var float: Double? {
        get {
            switch self {
            case let .Float(state):		return	state
            default:					return	nil
            }
        }
    }
}

public extension JSONValue {
//    public func asObject() throws -> RFC4627.Object {
//        switch self {
//        case let Object(state):     return state
//        default:					throw JSON.Error("This is not a JSON Object. (`\(self)`)")
//        }
//    }
//    public func asArray() throws -> RFC4627.Array {
//        switch self {
//        case let Array(state):      return state
//        default:					throw JSON.Error("This is not a JSON Array. (`\(self)`)")
//        }
//    }
//    public func asString() throws -> Swift.String {
//        switch self {
//        case let String(state):     return state
//        default:					throw JSON.Error("This is not a JSON String. (`\(self)`)")
//        }
//    }
//    public func asNumber() throws -> JSONNumber {
//        switch self {
//        case let Number(state):     return state
//        default:					throw JSON.Error("This is not a JSON Number. (`\(self)`)")
//        }
//    }
//    public func asBoolean() throws -> Bool {
//        switch self {
//        case let Boolean(state):    return state
//        default:					throw JSON.Error("This is not a JSON Boolean. (`\(self)`)")
//        }
//    }
//    public func asNull() throws -> () {
//        switch self {
//        case let Null(state):       return state
//        default:					throw JSON.Error("This is not a JSON Null. (`\(self)`)")
//        }
//    }

    public var object: JSONObject? {
        get {
            switch self {
            case let .Object(state):		return	state
            default:					return	nil
            }
        }
    }
    public var array: [JSONValue]? {
        get {
            switch self {
            case let .Array(state):		return	state
            default:					return	nil
            }
        }
    }
    public var string: Swift.String? {
        get {
            switch self {
            case let .String(state):		return	state
            default:					return	nil
            }
        }
    }
    public var number: JSONNumber? {
        get {
            switch self {
            case let .Number(state):		return	state
            default:					return	nil
            }
        }
    }
    public var boolean: Bool? {
        get {
            switch self {
            case let .Boolean(state):	return	state
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
            case .Null: return	()
            default:	return	nil
            }
        }
    }
}








///	MARK:
///	MARK:	Literals
///	MARK:
extension JSONValue: ExpressibleByNilLiteral, ExpressibleByBooleanLiteral, ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral, ExpressibleByStringLiteral, ExpressibleByExtendedGraphemeClusterLiteral, ExpressibleByUnicodeScalarLiteral, ExpressibleByArrayLiteral, ExpressibleByDictionaryLiteral {
	public typealias	Key		=	Swift.String
	public typealias	Value	=	JSONValue
	public typealias	Element	=	JSONValue
	
	public init(nilLiteral: ()) {
		self = Value.Null(())
	}
	public init(booleanLiteral value: BooleanLiteralType) {
		self = Value.Boolean(value)
	}
	public init(integerLiteral value: IntegerLiteralType) {
		self = Value.Number(JSONNumber.Integer(Int64(value)))
	}
	public init(floatLiteral value: FloatLiteralType) {
		self = Value.Number(JSONNumber.Float(Float64(value)))
	}
	public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterType) {
		self.init(stringLiteral: value)
	}
	public init(stringLiteral value: StringLiteralType) {
		self = Value.String(value)
	}
	public init(unicodeScalarLiteral value: UnicodeScalarType) {
		self.init(stringLiteral: value)
	}
	public init(arrayLiteral elements: Element...) {
		self = Value.Array(elements)
	}
	public init(dictionaryLiteral elements: (Key, Value)...) {
		var	o1 = [:] as [Key:Value]
		for (k,v) in elements {
			o1[k] = v
		}
		self = Value.Object(o1)
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


































































































































