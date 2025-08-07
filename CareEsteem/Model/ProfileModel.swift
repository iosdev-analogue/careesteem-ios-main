//
//  ProfileModel.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 13/03/25.
//


import Foundation

// MARK: - ProfileModel
struct ProfileModel: Codable {
    let userID: String?
    let name, agency, contactNumber, email: String?
    let age: Int?
    let address, city, postcode, profilePhoto: String?
    let profilePhotoName: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case name
        case agency = "Agency"
        case contactNumber = "contact_number"
        case email, age, address, city, postcode
        case profilePhoto = "profile_photo"
        case profilePhotoName = "profile_image_url"
    }
}
