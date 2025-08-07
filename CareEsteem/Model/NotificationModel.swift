//
//  NotificationModel.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 13/03/25.
//


import Foundation

// MARK: - NotificationModel
struct NotificationModel: Codable {
    let id, clientID, userID, visitDetailsID: String?
    let notificationTitle, notificationBody, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case clientID = "client_id"
        case userID = "user_id"
        case visitDetailsID = "visit_details_id"
        case notificationTitle = "notification_title"
        case notificationBody = "notification_body"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
