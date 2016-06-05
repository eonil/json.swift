//
//  JSON.Value.swift
//  Monolith
//
//  Created by Hoon H. on 10/20/14.
//
//

import Foundation

public extension JSON {
    ///	Explicitly typed representation.
    public enum Value : Equatable {
        case Object(JSON.Object)
        case Array(JSON.Array)
        case String(Swift.String)
        case Number(JSON.Number)
        case Boolean(Bool)
        /// JSON Null is treated as an actual value of type `()`.
        /// So it's different with `Optional.None`.
        case Null(())
    }

    public typealias	Object	=	[Swift.String:Value]
    public typealias	Array	=	[Value]

	///	Arbitrary precision number container.
	public enum Number : Equatable {
		case Integer(Int64)
		case Float(Double)
//		case Decimal(NSDecimalNumber)		//	Very large sized decimal number.
//		case Arbitrary(expression:String)	//	Arbitrary sized integer/real number expression.
		
		public var integer:Int64? {
			get {
				switch self {
				case let Integer(state):	return	state
				default:					return	nil
				}
			}
		}
		public var float:Double? {
			get {
				switch self {
				case let Float(state):		return	state
				default:					return	nil
				}
			}
		}
	}
}

public extension JSON.Value {
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
//    public func asNumber() throws -> JSON.Number {
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

    public var object: JSON.Object? {
        get {
            switch self {
            case let Object(state):		return	state
            default:					return	nil
            }
        }
    }
    public var array: [JSON.Value]? {
        get {
            switch self {
            case let Array(state):		return	state
            default:					return	nil
            }
        }
    }
    public var string: Swift.String? {
        get {
            switch self {
            case let String(state):		return	state
            default:					return	nil
            }
        }
    }
    public var number: JSON.Number? {
        get {
            switch self {
            case let Number(state):		return	state
            default:					return	nil
            }
        }
    }
    public var boolean: Bool? {
        get {
            switch self {
            case let Boolean(state):	return	state
            default:					return	nil
            }
        }
    }
    /// Checks current value is actually a *JSON Null*.
    /// JSON Null is treated as an actual value of type `()`.
    public var null: ()? {
        get {
            switch self {
            case Null:                  return	()
            default:					return	nil
            }
        }
    }
}

public extension JSON {
	public static func deserialise(data:NSData) throws -> JSON.Value? {
		let	o2:AnyObject = try NSJSONSerialization.JSONObjectWithData(data, options: [])
		let	o3 = try Converter.convertFromOBJ(o2)
		return o3
	}
	
	public static func serialise(value:JSON.Value) throws -> NSData? {
		return try serialise(value, allowFragment: false)
	}
	///	This does not allow serialisation of fragment. A JSON value must be one
	///	of object or array type. This limitation is due to limitation of `NSJSONSerialization` class.
	static func serialise(value:JSON.Value, allowFragment:Bool) throws -> NSData? {
		assert(value.object != nil || value.array != nil)
		let	o2:AnyObject	=	Converter.convertFromSwift(value)
//		let	d3:NSData?		=	NSJSONSerialization.dataWithJSONObject(o2, options: (NSJSONWritingOptions.allZeros) | NSJSONWritingOptions.PrettyPrinted), error: &e1)
		let	d3:NSData		=	try NSJSONSerialization.dataWithJSONObject(o2, options: [.PrettyPrinted])
		return d3
	}
}









///	MARK:
///	MARK:	Literals
///	MARK:
extension JSON.Value : NilLiteralConvertible, BooleanLiteralConvertible, IntegerLiteralConvertible, FloatLiteralConvertible, StringLiteralConvertible, ExtendedGraphemeClusterLiteralConvertible, UnicodeScalarLiteralConvertible, ArrayLiteralConvertible, DictionaryLiteralConvertible {
	public typealias	Key		=	Swift.String
	public typealias	Value	=	JSON.Value
	public typealias	Element	=	JSON.Value
	
	public init(nilLiteral: ()) {
		self = Value.Null(())
	}
	public init(booleanLiteral value: BooleanLiteralType) {
		self = Value.Boolean(value)
	}
	public init(integerLiteral value: IntegerLiteralType) {
		self = Value.Number(JSON.Number.Integer(Int64(value)))
	}
	public init(floatLiteral value: FloatLiteralType) {
		self = Value.Number(JSON.Number.Float(Float64(value)))
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
/////	`JSON.Value` is treated as an array when you enumerate on it.
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
		if v1 is NSNumber {
			let	v2	=	v1 as! NSNumber
			///	`NSNumber` can be a `CFBoolean` exceptionally if it was created from a boolean value.
			if CFGetTypeID(v2) == CFBooleanGetTypeID() {
				let	v3	=	CFBooleanGetValue(v2)
				return	Value.Boolean(v3)
			}
			if CFNumberIsFloatType(v2) {
				return	Value.Number(JSON.Number.Float(v2.doubleValue))
			} else {
				return	Value.Number(JSON.Number.Integer(v2.longLongValue))
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



























































































