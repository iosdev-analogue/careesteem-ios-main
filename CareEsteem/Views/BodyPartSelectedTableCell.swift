//
//  BodyPartSelectedTableCell.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 11/03/25.
//


import UIKit
class BodyPartSelectedTableCell:UITableViewCell{
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var btnClick: AGButton!
    var clickHandler:(()->Void)?
    override func awakeFromNib() {
        self.btnClick.action = {
            self.clickHandler?()
        }
    }
    func setupData(model:SelectedBodyPart){
        self.lblName.text = model.name
        self.img.image =  model.updatedImage
    }
    
    func setupData(name: String?, imageUrl: String?) {
        btnClick.isHidden = true
        self.lblName.text = name
        self.img.sd_setImage(with: URL(string: imageUrl ?? ""))
    }
}

