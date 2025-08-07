//
//  ClientNameModel.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 10/03/25.
//

import UIKit

// MARK: - ClientNameModel
struct ClientNameModel: Codable {
    let visitDetailsID, clientID, clientName, visitDate: String?

    enum CodingKeys: String, CodingKey {
        case clientID = "clientId"
        case visitDetailsID = "visitDetailsId"
        case clientName, visitDate
    }
}
