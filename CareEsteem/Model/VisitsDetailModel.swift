//
//  VisitsDetailModel.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 15/03/25.
//
import Foundation

// MARK: - VisitsDetailModel
struct VisitsDetailModel: Codable {
    let id, clientID, visitDetailsID: String?
    let userID, actualStartTime: String?
    let actualEndTime, status: String?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case clientID = "client_id"
        case visitDetailsID = "visit_details_id"
        case userID = "user_id"
        case actualStartTime = "actual_start_time"
        case actualEndTime = "actual_end_time"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
