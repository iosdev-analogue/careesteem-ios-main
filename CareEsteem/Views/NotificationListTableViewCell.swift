//
//  NotificationListTableViewCell.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 09/03/25.
//


import UIKit
class NotificationListTableViewCell:UITableViewCell{
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    func setupData(model:NotificationModel){
        lblName.text = model.notificationTitle
        lblDesc.text = model.notificationBody
        let createdAt = convertStringToDate(dateString: model.createdAt ?? "", format: "yyyy-MM-dd'T'HH:mm:ss.SSS")
        self.lblTime.text = convertDateToString(date: createdAt ?? Date(), format: "dd/MM/yyyy", timeZone: TimeZone(identifier: "Europe/London"))
    }
}
