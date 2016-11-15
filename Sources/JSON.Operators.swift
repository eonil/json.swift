//
//  JSON.Operators.swift
//  Monolith
//
//  Created by Hoon H. on 10/21/14.
//
//

public func == (l:JSONValue, r:JSONValue) -> Bool {
	typealias Value = JSONValue
	switch (l,r) {
	case let (.Null(l2),    .Null(r2)):     return	l2 == r2
	case let (.Boolean(l2),	.Boolean(r2)):	return	l2 == r2
	case let (.Number(l2),	.Number(r2)):	return	l2 == r2
	case let (.String(l2),	.String(r2)):	return	l2 == r2
	case let (.Array(l2),	.Array(r2)):	return	l2 == r2
	case let (.Object(l2),	.Object(r2)):	return	l2 == r2
	default:								return	false
	}
}
public func == (l:JSONNumber, r:JSONNumber) -> Bool {
	typealias	Value	=	JSONNumber
	switch (l,r) {
	case let (.Integer(l2), .Integer(r2)):	return	l2 == r2
	case let (.Float(l2),	.Float(r2)):	return	l2 == r2
	default:								return	false
	}
}
public func == (l:JSONValue, r:()) -> Bool {
	return l.null == r
}
public func == (l:JSONValue, r:Bool) -> Bool {
	return l.boolean == r
}
public func == (l:JSONValue, r:Int64) -> Bool {
	if let v1 = l.number?.integer {
		return v1 == r
	}
	return false
}
public func == (l:JSONValue, r:Float64) -> Bool {
	if let v1 = l.number?.float {
		return v1 == r
	}
	return false
}
public func == (l:JSONValue, r:String) -> Bool {
	return l.string == r
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
private func == (a: ()?, b: ()?) -> Bool {
    return a.isNone() == b.isNone()
}
private extension Optional {
    func isNone() -> Bool {
        switch self {
        case .none: return true
        default:    return false
        }
    }
}














