//
//  CodableValue.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 08/03/25.
//

import Foundation

struct CodableValue: Codable {
    let value: Any

    init(_ value: Any) {
        self.value = value
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch value {
        case let v as String:
            try container.encode(v)
        case let v as Int:
            try container.encode(v)
        case let v as Double:
            try container.encode(v)
        case let v as Bool:
            try container.encode(v)
        case let v as [String: CodableValue]:
            try container.encode(v)
        case let v as [CodableValue]:
            try container.encode(v)
        default:
            throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "Unsupported type"))
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let v = try? container.decode(String.self) {
            value = v
        } else if let v = try? container.decode(Int.self) {
            value = v
        } else if let v = try? container.decode(Double.self) {
            value = v
        } else if let v = try? container.decode(Bool.self) {
            value = v
        } else if let v = try? container.decode([String: CodableValue].self) {
            value = v
        } else if let v = try? container.decode([CodableValue].self) {
            value = v
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unsupported type")
        }
    }
}

