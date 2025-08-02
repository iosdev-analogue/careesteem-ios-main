//
//  NotCompletedVisitsTableCell.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 27/04/25.
//

import UIKit
import GooglePlaces

class NotCompletedVisitsTableCell:UITableViewCell{
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblCheckin: UILabel!
    @IBOutlet weak var lblCheckout: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var btnCheckin: AGButton!
    @IBOutlet weak var btnRoute: AGButton!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnCheckin.action = {
            if (self.object?.visitType ?? "") == "Unscheduled"{
                
                let vc = Storyboard.Visits.instantiateViewController(withViewClass: UnscheduleViewController.self)
                vc.visit =  self.object
                vc.visitType = .notcompleted
                AppDelegate.shared.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            }else{
//                let vc = Storyboard.Visits.instantiateViewController(withViewClass: ScheduleViewController.self)
//                vc.visit =  self.object
//                vc.visitType = .notcompleted
//                AppDelegate.shared.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            }
        }
           self.btnRoute.action = {
            let placesClient = GMSPlacesClient.shared()
            placesClient.lookUpPlaceID(self.object?.placeID ?? "", callback: { (place, error) in
                if let error = error {
                    print("lookup place id query error: \(error.localizedDescription)")
                    return
                }

                guard let place = place else {
                    print("No place details")
                    return
                }

                let searchedLatitude = place.coordinate.latitude
                let searchedLongitude = place.coordinate.longitude
                
                let url =  "http://maps.apple.com/maps?saddr=&daddr=\(searchedLatitude),\(searchedLongitude))"
                UIApplication.shared.open(URL(string: "\(url)")!,options: [:],
                completionHandler: nil)
            })

        }
    }
     var object:VisitsModel?
     func setupData(model:VisitsModel){
        self.object = model
        self.lblName.text = model.clientName
//        if var components = model.clientName?.components(separatedBy: " "), components.count > 1 {
//            self.lblName.text = components.last
//        }
        self.lblAddress.text = model.clientAddress
        self.lblTime.text =  (model.totalActualTimeDiff?.first ?? "").isEmpty ? "00:00" : (model.totalActualTimeDiff?.first ?? "")
   
        self.lblCount.text = (model.usersRequired?.value as? Int ?? 0).description
        self.lblCheckin.text = "Planned Start Time "+(model.plannedStartTime ?? "")
        self.lblCheckout.text = "Planned End Time "+(model.plannedEndTime ?? "")
        
        self.btnCheckin.setTitle("Not Completed", for: .normal)
         
         if (self.object?.visitType ?? "") == "Unscheduled"{
             self.btnCheckin.isHidden = false
         }else {
             self.btnCheckin.isHidden = true
         }
//        if (model.actualStartTime?.first ?? "").isEmpty{
//        }else{
//            self.btnCheckin.setTitle("Checkout", for: .normal)
//        }
    }
}



