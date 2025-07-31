//
//  OngoingVisitsTableCell.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 09/03/25.
//


import UIKit

class OngoingVisitsTableCell:UITableViewCell{
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnCheckout: AGButton!
   
    @IBOutlet weak var planTimeLbl: UILabel!
    private var visitTimer: Timer?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.visitTimer?.invalidate()
        self.visitTimer = nil
        self.btnCheckout.action = {
            if (self.object?.actualStartTime?.first ?? "").isEmpty{
                if convertDateToString(date:Date(), format: "yyyy-MM-dd",timeZone: TimeZone(identifier: "Europe/London")) == self.object?.visitDate{
                    let vc = Storyboard.Visits.instantiateViewController(withViewClass: CheckinCheckoutViewController.self)
                    vc.visit =  self.object
                    vc.isCheckin = true
                    AppDelegate.shared.topViewController()?.navigationController?.pushViewController(vc, animated: true)
                }
            }else{
                var params = [:] as [String : Any]
                CustomLoader.shared.showLoader(on: AppDelegate.shared.topViewController()?.view ?? self.parentViewController?.view ?? UIView())
                WebServiceManager.sharedInstance.callAPI(apiPath: .gettodoessentialdetails(visitId: (self.object?.visitDetailsID ?? "").description), method: .get, params: params,isAuthenticate: true, model: EmptyReponse.self) { response, successMsg in
                    CustomLoader.shared.hideLoader()
                    switch response {
                    case .success(let data):
                        DispatchQueue.main.async { [weak self] in
                            if data.statusCode == 200{
                                let vc = Storyboard.Visits.instantiateViewController(withViewClass: CheckinCheckoutViewController.self)
                                vc.visit =  self?.object
                                vc.isCheckin = false
                                AppDelegate.shared.topViewController()?.navigationController?.pushViewController(vc, animated: true)
                            }else{
                                AppDelegate.shared.topViewController()?.view.makeToast("Please first complete all essential")
                            }
                        }
                    case .failure(let error):
                        DispatchQueue.main.async { [weak self] in
                            AppDelegate.shared.topViewController()?.view.makeToast(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        visitTimer?.invalidate()
        visitTimer = nil
    }
    var object:VisitsModel?
    func setupData(model:VisitsModel){
        self.object = model
        self.lblName.text = model.clientName
        planTimeLbl.text = "Planned Time : \(model.plannedStartTime ?? "") - \(self.object?.plannedEndTime ?? "")"
        if model.visitType == "Unscheduled" {
            planTimeLbl.text = "Planned Time : Unscheduled"
        }

//        if var components = model.clientName?.components(separatedBy: " "), components.count > 1 {
//            self.lblName.text = components.last
//        }
        self.lblAddress.text = model.clientAddress
        if let clientPostcode = model.clientPostcode, let clientCity = model.clientCity{
            self.lblAddress.text = ( model.clientAddress ?? "") + "\n" + clientCity + ", " + clientPostcode
        }
        self.lblTime.text = (model.totalActualTimeDiff?.first ?? "").isEmpty ? "00:00" : (model.totalActualTimeDiff?.first ?? "")
        if (model.actualStartTime?.first ?? "").isEmpty{
            self.btnCheckout.setTitle("Checkin", for: .normal)
        }else{
            self.btnCheckout.setTitle("Checkout", for: .normal)
        }
        startVisitTimer()
    }
    private func startVisitTimer() {
        visitTimer?.invalidate()
        visitTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateVisitTime()
        }
        RunLoop.main.add(visitTimer!, forMode: .common)
        updateVisitTime()
    }
    private func updateVisitTime() {
        guard let startTimeStr = self.object?.actualStartTime?.first, !startTimeStr.isEmpty else {
            self.lblTime.text = "00:00"
            return
        }

        guard let visitDateStr = self.object?.visitDate, !visitDateStr.isEmpty else {
            self.lblTime.text = "00:00"
            return
        }

        let fullDateTimeStr = "\(visitDateStr) \(startTimeStr)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = .current//TimeZone(identifier: "Europe/London")

        if let startDate = dateFormatter.date(from: fullDateTimeStr) {
            let currentDate = Date()
            let calendar = Calendar.current
            let firstTime = startDate > currentDate ? currentDate : startDate
            let lastTime = startDate > currentDate ? startDate : currentDate
            let components = calendar.dateComponents([.hour, .minute, .second], from: lastTime, to: firstTime)

//            if currentDate < startDate {
//                self.lblTime.text = "Time's up!"
//                return
//            }
            let hours = components.hour ?? 0
            var  minutes = components.minute ?? 0
            var seconds = components.second ?? 0
            if minutes < 0 {
                minutes = minutes * (-1)
            }
            if seconds < 0 {
                seconds = seconds * (-1)
            }
//            if hours > 0 {
//                self.lblTime.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
//            } else {
                self.lblTime.text = String(format: "%02d:%02d", minutes, seconds)
//            }
        } else {
            self.lblTime.text = "00:00"
        }
    }
}
