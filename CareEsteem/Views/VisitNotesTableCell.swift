//
//  VisitNotesTableCell.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 10/03/25.
//


import UIKit
class VisitNotesTableCell:UITableViewCell{
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblNotes: UILabel!
    @IBOutlet weak var btnClick: AGButton!
    
    var clickHandler:(()->Void)?
    override func awakeFromNib() {
        self.btnClick.action = {
            self.clickHandler?()
        }
    }
    func setupData(model:VisitNotesModel){
        
        self.lblName.text = ""
        if let updatedAt = convertStringToDate(dateString: model.updatedAt ?? "", format: "yyyy-MM-dd HH:mm:ss"){
           self.lblName.text = "Updated by: \(model.updatedByUserName ?? "")"
           self.lblTime.text = convertDateToString(date: updatedAt, format: "dd/MM/yyyy 'at' hh:mm a")
       }else if let createdAt = convertStringToDate(dateString: model.createdAt ?? "", format: "yyyy-MM-dd HH:mm:ss"){
            self.lblName.text = "Created by: \(model.createdByUserName ?? "")"
            self.lblTime.text = convertDateToString(date: createdAt, format: "dd/MM/yyyy 'at' hh:mm a")
        }
        self.lblNotes.text = model.visitNotes
    }
}


