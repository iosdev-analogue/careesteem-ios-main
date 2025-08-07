//
//  VisitTodoModel.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 09/03/25.
//


import Foundation

// MARK: - VisitTodoModel
struct VisitTodoModel: Codable {
    let todoDetailsID: String?
    let todoEssential: Bool?
    let todoName, additionalNotes, carerNotes, todoOutcome: String?

    enum CodingKeys: String, CodingKey {
        case todoDetailsID = "todoDetailsId"
        case todoName, additionalNotes, carerNotes, todoOutcome,todoEssential
    }
}



