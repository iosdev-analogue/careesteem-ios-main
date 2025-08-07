//
//  AlertModel.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 08/03/25.
//
import Foundation
// MARK: - AlertModel
struct AlertModel: Codable {
    let id, userID: String?
    let chooseSessions: String?
    let visitDetailsID, sessionType, sessionTime, severityOfConcern, concernDetails: String?
    let bodyPartType, bodyPartNames, bodyImage: [String]?
    let clientName, clientID, userName, createdAt: String?
    var isExpand:Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case clientID = "client_id"
        case userID = "user_id"
        case visitDetailsID = "visit_details_id"
        case chooseSessions = "choose_sessions"
        case sessionType = "session_type"
        case sessionTime = "session_time"
        case severityOfConcern = "severity_of_concern"
        case concernDetails = "concern_details"
        case bodyPartType = "body_part_type"
        case bodyPartNames = "body_part_names"
        case bodyImage = "body_map_image_url"
        case clientName = "client_name"
        case userName = "user_name"
        case createdAt = "created_at"
    }
}

