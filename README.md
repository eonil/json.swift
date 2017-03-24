EonilJSON
=========
Hoon H.

[![Build Status](https://travis-ci.org/eonil/json.swift.svg?branch=master)](https://travis-ci.org/eonil/json.swift)

In-memory data representation for `RFC4627`.

- Very strongly and explicitly typed.
    - Defines `JSONNumber` which is composition 
        of `Int64` and `Float64` types.
    - Treats "JSON Null" as a value, and mapped
        to `Void` type.
- Explicit. 
    - No implicit conversion at all. 
    - No literal supports at all.
    - No extras.
    - You MUST do everything explicitly.
    - If your JSON value is `null`, it becomes `Void()`
        value.
- Minimal feature set. Only one additional feature
    -- `JSONSerialization` support.
- In-memory types are OBJC runtime accesss free. 
    (though serialization still uses `JSONSerialization`)
- Small. Release build binary size can be down to around
    130KiB in optimal condition. (can be larger by conditions)

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
        switch v {
        case .int64(let v):
            // `v` is a `Int64`.
            break
        case .float64(let v):
            // `v` is a `Float64`.
            break
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
