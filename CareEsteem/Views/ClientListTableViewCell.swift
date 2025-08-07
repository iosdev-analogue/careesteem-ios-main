//
//  ClientListTableViewCell.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 09/03/25.
//


import UIKit
import SDWebImage


class ClientListTableViewCell:UITableViewCell{
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblRiskLevel: UILabel!
    
    @IBOutlet weak var moderateView: UIView!
    @IBOutlet weak var highView: UIView!
    @IBOutlet weak var lowView: UIView!
    
    func setupData(model:ClientModel){
        
        self.lblName.text = model.fullName
        self.lblPhone.text = model.contactNumber
        self.lblAddress.text = model.fullAddress
        self.lblRiskLevel.text = model.riskLevel
        self.imgProfile.image =  UIImage(named: "logo")
        
        self.imgProfile.sd_setImage(with: URL(string: model.profilePhoto ?? ""), placeholderImage: UIImage(named: "logo1"))
        self.moderateView.isHidden = true
        self.highView.isHidden = true
        self.lowView.isHidden = true
        if model.riskLevel?.lowercased() == "low"{
            self.lowView.isHidden = false
        }else if model.riskLevel?.lowercased() == "moderate"{
            self.moderateView.isHidden = false
            self.lowView.isHidden = false
        }else if model.riskLevel?.lowercased() == "high"{
            self.moderateView.isHidden = false
            self.highView.isHidden = false
            self.lowView.isHidden = false
        }
    }
}
