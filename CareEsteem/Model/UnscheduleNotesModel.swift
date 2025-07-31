//
//  UnscheduleNotesModel.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 10/03/25.
//


import Foundation

// MARK: - UnscheduleNotesModel
struct UnscheduleNotesModel: Codable {
    let id, visitDetailsID: String?
    let todoNotes, todoCreatedAt, todoUpdatedAt: String?
    let todoUserID: String?
    let medicationNotes, medicationCreatedAt, medicationUpdatedAt: String?
    let medicationUserID: String?
    let visitNotes, visitCreatedAt, visitUpdatedAt: String?
    let visitUserID: String?

    enum CodingKeys: String, CodingKey {
        case id
        case visitDetailsID = "visit_details_id"
        case todoNotes = "todo_notes"
        case todoCreatedAt = "todo_created_at"
        case todoUpdatedAt = "todo_updated_at"
        case todoUserID = "todo_user_id"
        case medicationNotes = "medication_notes"
        case medicationCreatedAt = "medication_created_at"
        case medicationUpdatedAt = "medication_updated_at"
        case medicationUserID = "medication_user_id"
        case visitNotes = "visit_notes"
        case visitCreatedAt = "visit_created_at"
        case visitUpdatedAt = "visit_updated_at"
        case visitUserID = "visit_user_id"
    }
}
