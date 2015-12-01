//
//  RFC4627.swift
//  Monolith
//
//  Created by Hoon H. on 10/20/14.
//
//

import Foundation


public struct JSON {
	///	Explicitly typed representation.
	public enum Value : Equatable {
		case Object(JSON.Object)
		case Array(JSON.Array)
		case String(Swift.String)
		case Number(JSON.Number)
		case Boolean(Bool)
		case Null
		
		public var object: [Swift.String:Value]? {
			get {				
				switch self {
				case let JSON.Value.Object(state):	return	state
				default:				return	nil
				}
			}
		}
		public var array: [Value]? {
			get {
				switch self {
				case let JSON.Value.Array(state):	return	state
				default:				return	nil
				}
			}
		}
		public var string: Swift.String? {
			get {
				switch self {
				case let JSON.Value.String(state):	return	state
				default:				return	nil
				}
			}
		}
		public var number: JSON.Number? {
			get {
				switch self {
				case let JSON.Value.Number(state):	return	state
				default:				return	nil
				}
			}
		}
		public var boolean: Bool? {
			get {
				switch self {
				case let JSON.Value.Boolean(state):	return	state
				default:				return	nil
				}
			}
		}
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

public extension JSON {
	public static func deserialise(data:NSData) throws -> JSON.Value {
		let	o2	=	try NSJSONSerialization.JSONObjectWithData(data, options: [])
		let	o3	=	try Converter.convertFromOBJC(o2)
		return	o3
	}
	
	public static func serialise(value:JSON.Value) throws -> NSData {
		return try serialise(value, allowFragment: false)
	}
	///	This does not allow serialisation of fragment. A JSON value must be one
	///	of object or array type. This limitation is due to limitation of `NSJSONSerialization` class.
	static func serialise(value:JSON.Value, allowFragment:Bool) throws -> NSData {
		assert(value.object != nil || value.array != nil)
		let	o2	=	Converter.convertFromSwift(value)
		let	d3	=	try NSJSONSerialization.dataWithJSONObject(o2, options: [.PrettyPrinted])
		return	d3
	}
}









///	MARK:
///	MARK:	Literals
///	MARK:
extension JSON.Value : NilLiteralConvertible, BooleanLiteralConvertible, IntegerLiteralConvertible, FloatLiteralConvertible, StringLiteralConvertible, ExtendedGraphemeClusterLiteralConvertible, UnicodeScalarLiteralConvertible, ArrayLiteralConvertible, DictionaryLiteralConvertible {
	public typealias	Key	=	Swift.String
	public typealias	Value	=	JSON.Value
	public typealias	Element	=	JSON.Value
	
	public init(nilLiteral: ()) {
		self	=	Value.Null
	}
	public init(booleanLiteral value: BooleanLiteralType) {
		self	=	Value.Boolean(value)
	}
	public init(integerLiteral value: IntegerLiteralType) {
		self	=	Value.Number(JSON.Number.Integer(Int64(value)))
	}
	public init(floatLiteral value: FloatLiteralType) {
		self	=	Value.Number(JSON.Number.Float(Float64(value)))
	}
	public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterType) {
		self.init(stringLiteral: value)
	}
	public init(stringLiteral value: StringLiteralType) {
		self	=	Value.String(value)
	}
	public init(unicodeScalarLiteral value: UnicodeScalarType) {
		self.init(stringLiteral: value)
	}
	public init(arrayLiteral elements: Element...) {
		self	=	Value.Array(elements)
	}
	public init(dictionaryLiteral elements: (Key, Value)...) {
		var	o1	=	[:] as [Key:Value]
		for (k,v) in elements {
			o1[k]	=	v
		}
		self	=	Value.Object(o1)
	}
}









///	MARK:
///	MARK:	Collecion Support
///	MARK:

///	`JSON.Value` is treated as an array when you enumerate on it.
///	If underlying value is not an array, it will cause program crash.
///
extension JSON.Value : CollectionType {
	
	public var startIndex:Int {
		get {
			precondition(array != nil)
			return	array!.startIndex
		}
	}
	public var endIndex:Int {
		get {
			precondition(array != nil)
			return	array!.endIndex
		}
	}

	public subscript(name:Swift.String) -> Value? {
		get {
			return	object?[name]
		}
	}
	public subscript(index:Int) -> Value {
		get {
			return	array![index]
		}
	}
	
	public func generate() -> IndexingGenerator<[Value]> {
		precondition(array != nil, "Current `Value` does not contain an array.")
		return	array!.generate()
	}
	
	
	
	
	
	
	
}





























































///	MARK:
///	MARK:	Private Stuffs
///	MARK:

///	Converts JSON tree between Objective-C and Swift representations.
private struct Converter {
	typealias	Value	=	JSON.Value

	enum ConversionFromObjectiveCError: ErrorType {
		case InputIsNotAnObjectiveCObject
		case InputDictionaryKeyIsNotString
		case InputIsUnsupportedTypeObject(inputObject: AnyObject)
	}

	///	Objective-C `nil` is not supported as an input.
	///	Use `NSNull` which is standard way to represent `nil`
	///	in data-structures in Cocoa.
	static func convertFromOBJC(v1: AnyObject) throws -> Value {
		assert(v1 is NSObject)
		func convertArray(v1: NSArray) throws -> Value {
			var a2 = [Value]()
			for m1 in v1 {
				///	Must be an OBJC type.
				guard let m1 = m1 as? NSObject else {
					throw ConversionFromObjectiveCError.InputIsNotAnObjectiveCObject
				}
				let m2 = try self.convertFromOBJC(m1)
				a2.append(m2)
			}
			return	Value.Array(a2)
		}
		func convertObject(v1: NSDictionary) throws -> Value {
			var o2 = [String:Value]()
			for p1 in v1 {
				guard let k1 = p1.key as? String else {
					throw ConversionFromObjectiveCError.InputDictionaryKeyIsNotString
				}
				let v2 = try self.convertFromOBJC(p1.value)
				o2[k1] = v2
			}
			return	Value.Object(o2)
		}

		if let _ = v1 as? NSNull {
			return Value.Null
		}
		if let v2 = v1 as? NSNumber {
			///	`NSNumber` can be a `CFBoolean` exceptionally if it was created from a boolean value.
			if CFGetTypeID(v2) == CFBooleanGetTypeID() {
				let v3 = CFBooleanGetValue(v2)
				return Value.Boolean(v3)
			}
			if CFNumberIsFloatType(v2) {
				return Value.Number(JSON.Number.Float(v2.doubleValue))
			} else {
				return Value.Number(JSON.Number.Integer(v2.longLongValue))
			}
		}
		if let v2 = v1 as? NSString {
			return Value.String(v2 as String)
		}
		if let v2 = v1 as? NSArray {
			return try convertArray(v2)
		}
		if let v2 = v1 as? NSDictionary {
			return try convertObject(v2)
		}
		throw ConversionFromObjectiveCError.InputIsUnsupportedTypeObject(inputObject: v1)
	}
	static func convertFromSwift(v1:Value) -> AnyObject {
		func convertArray(a1:[Value]) -> NSArray {
			let	a2	=	NSMutableArray()
			for m1 in v1.array! {
				let	m2:AnyObject	=	self.convertFromSwift(m1)
				a2.addObject(m2)
			}
			return	a2
		}
		func convertObject(o1:[String:Value]) -> NSDictionary {
			let	o2	=	NSMutableDictionary()
			for (k1, v1) in o1 {
				let	k2				=	k1 as NSString
				let	v2:AnyObject	=	self.convertFromSwift(v1)
				o2.setObject(v2, forKey: k2)
			}
			return	o2
		}
		
		switch v1 {
		case JSON.Value.Null:			return	NSNull()
		case let JSON.Value.Boolean(s1):	return	NSNumber(bool: s1)
		case let JSON.Value.Number(s1):
			switch s1 {
			case let JSON.Number.Integer(s2):	return	NSNumber(longLong: s2)
			case let JSON.Number.Float(s2):		return	NSNumber(double: s2)
			}
		case let JSON.Value.String(s1):		return	s1 as NSString
		case let JSON.Value.Array(s1):		return	convertArray(s1)
		case let JSON.Value.Object(s1):		return	convertObject(s1)
		}
	}
}











































































///	MARK:
extension JSON {
	struct Test {
		static func run() {
			func tx(c:()->()) {
				c()
			}
			
			
			
			
			
			tx {
				let	a1	=	"{ \"aaa\" : 123 }"
				let	a2	=	a1.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
				let	a3	=	try! JSON.deserialise(a2)
				
				let	a4	=	JSON.Value.Object([
					"aaa"	:	JSON.Value.Number(JSON.Number.Integer(123))
					])
				
				assert(a3 == a4)
			}
			
//			tx {
//				let	a1	=	[
//					"aaa"	:	nil,
//					"bbb"	:	true,
//					"ccc"	:	123,
//					"ddd"	:	456.789,
//					"eee"	:	"Here b a dragon.",
//					"fff"	:	["xxx", "yyy", "zzz"] as [Any?],
//					"ggg"	:	[
//						"f1"	:	"v1",
//						"f2"	:	"v2",
//						"f3"	:	"v3",
//					] as [String:Any?],
//				] as [String:Any?]
//				
//				println(a1["aaa"]!)
//				let	v1	=	a1["aaa"]!
//				assert(a1["aaa"]! == nil)
//				
//				let	a2	=	JSON.serialise(a1)!
//				println(a2)
//				
//				let	a3	=	JSON.deserialise(a2)!
//				println(a3)
//				
//				assert(a3 is [String:Any?])
//			}
			
			tx {
				let	a1	=	[
					"aaa"	:	nil,
					"bbb"	:	true,
					"ccc"	:	123,
					"ddd"	:	456.789,
					"eee"	:	"Here be a dragon.",
					"fff"	:	["xxx", "yyy", "zzz"],
					"ggg"	:	[
						"f1"	:	"v1",
						"f2"	:	"v2",
						"f3"	:	"v3",
						],
					] as Value
				
				print(a1.object!["aaa"]!)
				let	_	=	a1.object!["aaa"]!
				assert(a1.object!["aaa"]! == nil)
				
				let	a2	=	try! JSON.serialise(a1)
				print(a2)
				
				let	a3	=	try! JSON.deserialise(a2)
				print(a3)
				
				assert(a3 == a1)
			}
			
			tx {
				let	d1	=	"This is a dynamic text." as Value
				let	a1	=	[
					"aaa"	:	nil,
					"bbb"	:	true,
					"ccc"	:	123,
					"ddd"	:	456.789,
					"eee"	:	d1,
					"fff"	:	[d1, d1, d1],
					"ggg"	:	[
						"f1"	:	d1,
						"f2"	:	d1,
						"f3"	:	d1,
					],
					] as Value
				
				
				let	a2	=	try! JSON.serialise(a1)
				print(a2)
				
				let	a3	=	try! JSON.deserialise(a2)
				print(a3)
				
				assert(a3 == a1)
				
				print(a3.object!["aaa"]!)
				_	=	a3.object!["aaa"]!
				assert(a3.object!["aaa"]! == nil)
				assert(a3.object!["fff"]! == [d1, d1, d1])
			}

		}
	}
}
























