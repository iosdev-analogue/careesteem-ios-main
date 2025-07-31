//
//  VisitsModel.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 08/03/25.
//


import Foundation

// MARK: - VisitsModel
struct VisitsModel: Codable {
    var id: String?
    var visitDetailsID, clientID, clientName, clientAddress, clientCity: String?
    let userName: [String]?
    let totalPlannedTime, plannedStartTime, plannedEndTime: String?
    let visitDate, visitType, visitStatus: String?
    let usersRequired:CodableValue?
    let latitude, longitude, radius: CodableValue?
    let placeID: String?
    let chooseSessions: CodableValue?
    let sessionType, clientPostcode, sessionTime: String?
    let actualStartTime, actualEndTime: [String]?
    let totalActualTimeDiff: [String]?
    let profilePhotoName: [String?]?
    let profilePhoto: [String]?
    let userID: [String]?
    
    enum CodingKeys: String, CodingKey {
        case clientID = "clientId"
        case visitDetailsID = "visitDetailsId"
        case clientName, clientAddress, userName, clientPostcode, clientCity
        case userID = "userId"
        case totalPlannedTime, plannedStartTime, plannedEndTime, visitDate, visitType, visitStatus, usersRequired, latitude, longitude, radius
        case placeID = "placeId"
        case chooseSessions, sessionType, sessionTime, actualStartTime, actualEndTime
        case totalActualTimeDiff = "TotalActualTimeDiff"
        case profilePhotoName = "profile_photo_name"
        case profilePhoto = "profile_photo"
        case id
    }
}
