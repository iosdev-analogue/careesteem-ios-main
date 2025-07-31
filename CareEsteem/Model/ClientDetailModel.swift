//
//  ClientDetailModel.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 08/03/25.
//
import UIKit
import AVFoundation

// MARK: - ClientDetailModel
struct ClientDetailModel: Codable {
    let about: About?
    let myCareNetwork: [MyCareNetwork]?

    enum CodingKeys: String, CodingKey {
        case about = "About"
        case myCareNetwork = "MyCareNetwork"
    }
}

// MARK: - About
struct About: Codable {
    let clientID, clientPersonalID: String?
    let dateOfBirth: String?
    let age: CodableValue?
    let nhsNumber, gender, religion, maritalStatus: String?
    let ethnicity: String?

    enum CodingKeys: String, CodingKey {
        case clientID = "client_id"
        case clientPersonalID = "client_personal_id"
        case dateOfBirth = "date_of_birth"
        case age
        case nhsNumber = "nhs_number"
        case gender, religion
        case maritalStatus = "marital_status"
        case ethnicity
    }
}

// MARK: - MyCareNetwork
struct MyCareNetwork: Codable {
    let mycareNetworkID: String?
    let occupationType, name: String?
    let age: CodableValue?
    let contactNumber, email, address, city: String?
    let postCode: String?

    enum CodingKeys: String, CodingKey {
        case mycareNetworkID = "mycare_network_id"
        case occupationType = "occupation_type"
        case name, age
        case contactNumber = "contact_number"
        case email, address, city
        case postCode = "post_code"
    }
}

struct MyCustomListModel{
    var title:String = ""
    var key:String = ""
    var value:[MyPopupListModel] = []
    var risk:[RiskAssesstment] = []
}
struct MyPopupListModel{
    var title:String = ""
    var value:String = ""
}

struct RiskAssesstment{
    var name:String = ""
    var date:String = ""
    var isListItem:Bool = false
    var isBottom:Bool = false
    var value:[MyPopupListModel] = []
}


struct Documents: Codable {
    let id, agencyID, clientID, documentName: String
    let additionalInfo: String
    let attachDocument: [AttachDocument]
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case agencyID = "agency_id"
        case clientID = "client_id"
        case documentName = "document_name"
        case additionalInfo = "additional_info"
        case attachDocument = "attach_document"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - AttachDocument
struct AttachDocument: Codable {
    let filename: String
    let url: String
}
