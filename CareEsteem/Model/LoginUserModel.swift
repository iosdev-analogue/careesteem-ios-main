//
//  LoginUserModel.swift
//  SaudiGate
//
//  Created by Gaurav Gudaliya on 26/06/22.
//  Copyright © 2022 Gaurav Gudaliya R. All rights reserved.
//

import Foundation

// MARK: - LoginUserModel
struct LoginUserModel: Codable {
    let id: String?
    let prefix, firstName, middleName, lastName: String?
    let contactNumber, email: String?
    let admin: Int?
    let role, createdAt, token: String?
    let status: Int?
    let telephoneCodes: String?
    let tokenStatus: String?
    let updatedAt: String?
    let allocated: String?
    let otp: Int?
    let otpExpiresAt: String?
    let otpVerified: CodableValue?
    var passcode, hashToken: String?
    let hashTokenVerified: CodableValue?
    let fcmToken, tokenCreatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case prefix = "prefix"
        case firstName = "first_name"
        case middleName = "middle_name"
        case lastName = "last_name"
        case contactNumber = "contact_number"
        case email, admin, role
        case createdAt = "created_at"
        case token, status
        case telephoneCodes = "telephone_codes"
        case tokenStatus = "token_status"
        case updatedAt = "updated_at"
        case allocated, otp
        case otpExpiresAt = "otp_expires_at"
        case otpVerified = "otp_verified"
        case passcode
        case hashToken = "hash_token"
        case hashTokenVerified = "hash_token_verified"
        case fcmToken = "fcm_token"
        case tokenCreatedAt = "token_created_at"
    }
}

class AgencyModel: Codable {
    var id: String?
    var contact_number: String?
    var agency_id: String?
    var agency_name: String?
}

class SetPinModel: Codable {
    var insertId, affectedRows, changedRows: Int?
    var serverStatus: Int?
    var warningStatus: Int?
}
