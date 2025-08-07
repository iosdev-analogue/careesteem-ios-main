//
//  Country.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 11/03/25.
//


import Foundation

struct Country: Codable {
    let id: String
    let country: String
    let countryCode: String
    let emoji: String

    // Map JSON keys to Swift properties if needed
    enum CodingKeys: String, CodingKey {
        case id
        case country, emoji
        case countryCode = "country_code"
    }
}
