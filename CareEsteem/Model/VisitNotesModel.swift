//
//  VisitNotesModel.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 09/03/25.
//


import Foundation

// MARK: - VisitNotesModel
struct VisitNotesModel: Codable {
    let id: String?
    let visitNotes, createdAt, updatedAt: String?
    let createdByUserID: String?
    let createdByUserName: String?
    let updatedByUserID: String?
    let updatedByUserName: String?
    let visitDetaiID: String?

    enum CodingKeys: String, CodingKey {
        case id, visitNotes, createdAt, updatedAt
        case createdByUserID = "createdByUserId"
        case createdByUserName
        case updatedByUserID = "updatedByUserId"
        case updatedByUserName
        case visitDetaiID = "visitDetaiId"
    }
}

// MARK: - VisitNotesModel
struct AddResVisitNotesModel: Codable {
    let id: String?
    let visitNotes, createdAt, updatedAt: String?
    let createdByUserID: String?
    let updatedByUserID: String?
    let visitDetaiID: String?

    enum CodingKeys: String, CodingKey {
        case id, visitNotes
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case createdByUserID = "createdby_userid"
        case updatedByUserID = "updatedby_userid"
        case visitDetaiID = "visitDetaiId"
    }
}
