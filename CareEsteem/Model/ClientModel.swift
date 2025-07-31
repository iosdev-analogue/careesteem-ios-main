//
//  ClientModel.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 08/03/25.
//


import Foundation

// MARK: - ClientModel
struct ClientModel: Codable {
    let id: String?
    let fullName, fullAddress, riskLevel, contactNumber: String?
    let placeID, profilePhotoName, profilePhoto, createdAt: String?
    let radius:CodableValue?
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case fullAddress = "full_address"
        case riskLevel = "risk_level"
        case contactNumber = "contact_number"
        case placeID = "place_id"
        case profilePhotoName = "profile_photo_name"
        case profilePhoto = "profile_image_url"
        case createdAt = "created_at"
        case radius
    }
}
