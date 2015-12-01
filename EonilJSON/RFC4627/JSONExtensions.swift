//
//  JSONExtensions.swift
//  Monolith
//
//  Created by Hoon H. on 10/21/14.
//
//

import Foundation























/// Fragment description is missing due to lack of implementation in Cocoa.
/// We need to implement our own generator and parser.
extension JSON.Value: CustomStringConvertible {
	public var description: Swift.String {
		get {
//			switch self {
//			case let .Object(s):	return	"{}"
//			case let .Array(s):	return	"[]"
//			case let .String(s):	return	"\"\""
//			case let .Number(s):	return	""
//			case let .Boolean(s):	return	""
//			case let .Null:			return	"null"
//			}

			do {
				let	d1	=	try JSON.serialise(self)
				let	s2	=	NSString(data: d1, encoding: NSUTF8StringEncoding) as Swift.String? ?? ""
				return	s2 
			}
			catch let error {
				return	"\(error)"
			}
		}
	}
}
extension JSON.Value: CustomDebugStringConvertible {
	public var debugDescription: Swift.String {
		get {
			return	description
		}
	}
}




//private func escapeString(s:String) -> String {
//	func shouldEscape(ch1:Character) -> (shouldPrefix:Bool, specifier:Character) {
//		switch ch1 {
//		case "\u{0022}":	return	(true, "\"")
//		case "\u{005C}":	return	(true, "\\")
//		case "\u{002F}":	return	(true, "/")
//		case "\u{0008}":	return	(true, "b")
//		case "\u{000C}":	return	(true, "f")
//		case "\u{000A}":	return	(true, "n")
//		case "\u{000D}":	return	(true, "r")
//		case "\u{0009}":	return	(true, "t")
//		default:			return	(false, ch1)
//		}
//	}
//	typealias	Step	=	() -> Cursor
//	enum Cursor {
//		case None
//		case Available(Character, Step)
//		
//		static func restep(s:String) -> (Character, Step) {
//			let	first	=	s[s.startIndex] as Character
//			let	rest	=	s[s.startIndex.successor()..<s.endIndex]
//			let	step	=	Cursor.restep(rest)
//			return	(first, step)
//		}
//	}
//	
//	return	step1
//}



























