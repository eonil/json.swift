EonilJSON
=========
Hoon H.

[![Build Status](https://travis-ci.org/eonil/json.swift.svg?branch=master)](https://travis-ci.org/eonil/json.swift)

In-memory representation for `RFC7159`.
This tries to resemble JSON AST which follows JavaScript 
semantics closely as much as possible.

- OBJC runtime free (in-memory representation only)
    - No vague `NSObject`, `NSArray`, `NSDictionary` and
        `NSNumber`. (serialization still uses 
        `JSONSerialization` internally)
    - Defines `JSONNumber` which is composition 
        of `Int64` and `Float64` types.
    - Treats "null" as a value, and mapped
        to `Void` type.

- Safer.
    - Checks and declines for unacceptable values like
        `nan` or `infinity` at first place.
    - Once you created a JSON tree, That's a valid JSON.
    
- More explicit. 
    - No implicit conversion at all. 
    - No literal supports at all.
    - If your JSON value is `null`, it becomes `Void()`
        value.

- Smaller.
    - Minimal feature set. No extras.
    - Now this is provided as a static library. Link only what you want.

Take care that this is not CST. This is an AST intended to be
used as a part of static serialization code.

Quickstart
----------

    import EonilJSON
    
    let d = getData()
    let j = try JSON.deserialize(d)

    switch j {
    case .null(let v):
        // `v` is a `Void`.
        break
    case .boolean(let v):
        // `v` is a `Bool`.
        break
    case .number(let v):
        // `v` is an `Int64` if
        // the number is parsed
        // as an integer.
        // Otherwise it is a 
        // `Float64`.
        if let v1 = v.int64 {
            // `v1` is a `Int64`.
        }
        if let v1 = v.float64 {
            // `v1` is a `Float64`.
        }
        break
    case .string(let v):
        // `v` is a `String`.
        break
    case .array(let v):
        // `v` is a `[JSONValue]`.
        break
    case .object(let v):
        // `v` is a `[String: JSONValue]`.
        break
    }

See `JSONValue` type for details.



License
-------
MIT License.
