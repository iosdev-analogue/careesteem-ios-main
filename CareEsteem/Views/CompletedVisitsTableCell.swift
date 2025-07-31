//
//  CompletedVisitsTableCell.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 09/03/25.
//


import UIKit

class CompletedVisitsTableCell:UITableViewCell{
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblCheckin: UILabel!
    @IBOutlet weak var lblCheckout: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var lblName1: UILabel!
    @IBOutlet weak var lblName2: UILabel!
    @IBOutlet weak var img1: AGImageView!
    @IBOutlet weak var img2: AGImageView!
    
    @IBOutlet weak var unscheduleLbl: AGView!
    @IBOutlet weak var btnView: AGButton!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnView.action = {
            if (self.object?.visitType ?? "") == "Unscheduled"{
                let vc = Storyboard.Visits.instantiateViewController(withViewClass: UnscheduleViewController.self)
                vc.visit =  self.object
                vc.visitType = .completed
                AppDelegate.shared.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = Storyboard.Visits.instantiateViewController(withViewClass: ScheduleViewController.self)
                vc.visit =  self.object
                vc.visitType = .completed
                AppDelegate.shared.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    var object:VisitsModel?
    func setupData(model:VisitsModel){
        self.object = model
        self.lblName.text = model.clientName
        unscheduleLbl.isHidden = model.visitType != "Unscheduled"
//        if var components = model.clientName?.components(separatedBy: " "), components.count > 1 {
//            self.lblName.text = components.last
//        }
        self.lblAddress.text = model.clientAddress
        if let clientPostcode = model.clientPostcode, let clientCity = model.clientCity{
            self.lblAddress.text = ( model.clientAddress ?? "") + "\n" + clientCity + ", " + clientPostcode
        }
        self.lblTime.text = (model.totalActualTimeDiff?.first ?? "").isEmpty ? "00:00" : (model.totalActualTimeDiff?.first ?? "")
        
        if (model.userName?.count ?? 0) > 0{
            self.lblName1.text = model.userName?[0]
        }else{
            self.lblName1.text = ""
        }
        if (model.userName?.count ?? 0) > 1{
            self.lblName2.text = model.userName?[1]
        }else{
            self.lblName2.text = ""
        }
        
        if (model.profilePhotoName?.count ?? 0) > 0{
            if let profilePhotoName = model.profilePhotoName?[0] {
                self.img1.sd_setImage(with: URL(string: model.profilePhotoName?[0] ?? ""), placeholderImage: UIImage(named: "logo1"))
            } else {
                self.img1.image = Photo().imageWith(name:model.userName?[0] ?? "")//?? UIImage(named: "logo1")
            }
        }
        if (model.profilePhotoName?.count ?? 0) > 1{
            if let profilePhotoName = model.profilePhotoName?[1] {
                self.img2.sd_setImage(with: URL(string: profilePhotoName), placeholderImage: UIImage(named: "logo1"))
            } else {
                self.img2.image = Photo().imageWith(name:model.userName?[1] ?? "")//?? UIImage(named: "logo1")
            }
            self.img2.sd_setImage(with: URL(string: model.profilePhotoName?[1] ?? ""), placeholderImage: UIImage(named: "logo1"))
        }
        self.img1.isHidden = true
        self.img2.isHidden = true
        self.lblName1.isHidden = true
        self.lblName2.isHidden = true
        if (model.usersRequired?.value as? Int ?? 0) == 1{
            self.img1.isHidden = false
            self.lblName1.isHidden = false
        }else if (model.usersRequired?.value as? Int ?? 0) >= 2{
            self.img1.isHidden = false
            self.img2.isHidden = false
            self.lblName1.isHidden = false
            self.lblName2.isHidden = false
        }
        self.lblCheckin.text = model.actualStartTime?.first
        self.lblCheckout.text = model.actualEndTime?.first
        self.lblCount.text = (model.usersRequired?.value as? Int ?? 0).description
        if let start = model.actualStartTime?.first, start.count > 5 {
            self.lblCheckin.text = String(start.prefix(5))
        }
        if let end = model.actualEndTime?.first, end.count > 5 {
            self.lblCheckout.text = String(end.prefix(5))
        }
        
    }
}


