//
//  BodyPartSectionTableCell.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 11/03/25.
//


import UIKit

class BodyPartSectionTableCell:UITableViewCell{
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgDropDown: UIImageView!
    @IBOutlet weak var btnClick: AGButton!
    var clickHandler:(()->Void)?
    override func awakeFromNib() {
        self.btnClick.action = {
            self.clickHandler?()
        }
    }
    func setupData(model:BodyPartModel){
        self.lblName.text = model.name
        if model.isExpand ?? false{
            self.imgDropDown.image = UIImage(systemName: "chevron.up")
        }else{
            self.imgDropDown.image = UIImage(systemName: "chevron.down")
        }
    }
}


