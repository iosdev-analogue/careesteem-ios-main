//
//  BodyPartModel.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 11/03/25.
//


import Foundation
import UIKit

// MARK: - BodyPartModel
struct BodyPartModel: Codable {
    let name: String?
    let list: [PartItem]?
    var isExpand:Bool?
}

// MARK: - List
struct PartItem: Codable {
    let name, image: String?
}

// MARK: - List
class SelectedBodyPart: NSObject {
    var parent,name, image: String?
    var updatedImage:UIImage?
    var fileName:String?
    init(parent: String? = nil, name: String? = nil, image: String? = nil, updatedImage: UIImage? = nil) {
        self.parent = parent
        self.name = name
        self.image = image
        self.updatedImage = updatedImage
        self.fileName = Date().timeIntervalSince1970.description+".png"
    }
}
