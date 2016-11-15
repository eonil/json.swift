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
	case let (.null(l2),    .null(r2)):     return	l2 == r2
	case let (.boolean(l2),	.boolean(r2)):	return	l2 == r2
	case let (.number(l2),	.number(r2)):	return	l2 == r2
	case let (.string(l2),	.string(r2)):	return	l2 == r2
	case let (.array(l2),	.array(r2)):	return	l2 == r2
	case let (.object(l2),	.object(r2)):	return	l2 == r2
	default:								return	false
	}
}
public func == (l:JSONNumber, r:JSONNumber) -> Bool {
	typealias	Value	=	JSONNumber
	switch (l,r) {
	case let (.int64(l2),   .int64(r2)):	return	l2 == r2
	case let (.float(l2),	.float(r2)):	return	l2 == r2
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
	if let v1 = l.number?.int64 {
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














