//
//  JSONOperators.swift
//  EoniJSON
//
//  Created by Hoon H. on 10/21/14.
//
//

public func == (a: JSONValue, b: JSONValue) -> Bool {
    typealias Value = JSONValue
    switch (a, b) {
    case let (.null(l2),    .null(r2)):     return l2 == r2
    case let (.boolean(l2), .boolean(r2)):  return l2 == r2
    case let (.number(l2),  .number(r2)):   return l2 == r2
    case let (.string(l2),  .string(r2)):   return l2 == r2
    case let (.array(l2),   .array(r2)):    return l2 == r2
    case let (.object(l2),  .object(r2)):   return l2 == r2
    default:                                return false
    }
}
public func == (a: JSONNumber, b: JSONNumber) -> Bool {
    typealias Value = JSONNumber
    switch (a, b) {
    case let (.int64(l2),   .int64(r2)):    return l2 == r2
    case let (.float64(l2), .float64(r2)):  return l2 == r2
    default:                                return false
    }
}
public func == (_ a: JSONValue, _ b: Void) -> Bool {
    return a.null == b
}
public func == (_ a: JSONValue, _ b: Bool) -> Bool {
    return a.boolean == b
}
public func == (_ a: JSONValue, _ b: JSONNumber) -> Bool {
    return a.number == b
}
public func == (_ a: JSONValue, _ b: Int64) -> Bool {
    return a.number?.int64 == b
}
public func == (_ a: JSONValue, _ b: Float64) -> Bool {
    return a.number?.float64 == b
}
public func == (_ a: JSONValue, _ b: String) -> Bool {
    return a.string == b
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
private func == (a: Void?, b: Void?) -> Bool {
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
