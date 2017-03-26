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
    case let (.null(a1),    .null(b1)):     return a1 == b1
    case let (.boolean(a1), .boolean(b1)):  return a1 == b1
    case let (.number(a1),  .number(b1)):   return a1 == b1
    case let (.string(a1),  .string(b1)):   return a1 == b1
    case let (.array(a1),   .array(b1)):    return a1 == b1
    case let (.object(a1),  .object(b1)):   return a1 == b1
    default:                                return false
    }
}
public func == (a: JSONNumber, b: JSONNumber) -> Bool {
    typealias Value = JSONNumber
    switch (a.storage, b.storage) {
    case let (.int64(a1),   .int64(b1)):    return a1 == b1
    case let (.float64(a1), .float64(b1)):  return a1 == b1
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
