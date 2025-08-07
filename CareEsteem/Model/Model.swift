//
//  NewsFeedCommentModel.swift
//  Alfayda
//
//  Created by Wholly-iOS on 20/09/18.
//  Copyright © 2018 Whollysoftware. All rights reserved.
//

import UIKit

class CountryModel: Codable {
    var id: Int?
    var name: String?
    var dial_code: String?
    var flag: String?
    var en_name: String?
    
}
struct GCMNotificationModel: Codable {
    let title: String?
    let taskID, fromUserID: String?
    let taskGroupID, notificationType: String?
    let toUserID: String?
    let companyID, boardID: String?

    enum CodingKeys: String, CodingKey {
        case title = "gcm.notification.title"
        case taskID = "gcm.notification.task_id"
        case fromUserID = "gcm.notification.from_user_id"
        case taskGroupID = "gcm.notification.task_group_id"
        case notificationType = "gcm.notification.notification_type"
        case toUserID = "gcm.notification.to_user_id"
        case companyID = "gcm.notification.company_id"
        case boardID = "gcm.notification.board_id"
    }
}
