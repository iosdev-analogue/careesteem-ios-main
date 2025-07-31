//
//  VisitsSectionTableCell.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 09/03/25.
//


import UIKit

class VisitsSectionTableCell:UITableViewCell{
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgDropDown: UIImageView!
    @IBOutlet weak var bgView: AGView!
    @IBOutlet weak var btnClick: AGButton!
    var clickHandler:(()->Void)?
    override func awakeFromNib() {
        self.btnClick.action = {
            self.clickHandler?()
        }
    }
    func setupData(model:VisitsSectionModel){
        self.lblName.text = model.title + " (\(model.data.count))"
        if model.type == .completed{
            bgView.backgroundColor = UIColor(named: "appGreen")
        }else if model.type == .onging{
            bgView.backgroundColor = UIColor(named: "appBlue")
        }else if model.type == .upcoming{
            bgView.backgroundColor = UIColor(named: "appYellow")
        }else if model.type == .notcompleted{
            bgView.backgroundColor = UIColor(named: "appRed")
        }
        if model.isExpand{
            self.imgDropDown.image = UIImage(systemName: "chevron.up")
        }else{
            self.imgDropDown.image = UIImage(systemName: "chevron.down")
        }
    }
}

