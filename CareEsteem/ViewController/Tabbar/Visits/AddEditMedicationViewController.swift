//
//  AddEditMedicationViewController.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 14/03/25.
//

import UIKit
import DropDown

class AddEditMedicationViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnClose: AGButton!
    @IBOutlet weak var btnClose1: AGButton!
    @IBOutlet weak var btnSubmit: AGButton!
    @IBOutlet weak var btnStatus: AGButton!
    @IBOutlet weak var txtView: AGTextView!
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBOutlet weak var imageStackView: UIStackView!
    @IBOutlet weak var prnStack: UIStackView!
    @IBOutlet weak var bpStack: UIStackView!
    
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblSupport: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblRoute: UILabel!
    @IBOutlet weak var lblFrequancy: UILabel!
    @IBOutlet weak var main_view: AGView!
    @IBOutlet weak var scrollview: UIScrollView!
    
    var updateHandler:(()->Void)?
    var isEdit:Bool = false
    var mediFlag = false
    var medication:VisitMedicationModel?
    var visit:VisitsModel?
    override func viewDidLoad() {
        super.viewDidLoad()
//        heigthconstraint.constant = self.view.frame.height - 450
        scrollview.layer.cornerRadius = 15
        scrollview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        scrollview.clipsToBounds = true
        main_view.layer.cornerRadius = 15
        main_view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        main_view.clipsToBounds = true
        self.lblTitle.text = self.medication?.nhsMedicineName
       
        if self.medication?.medicationType == "PRN1"{
            self.prnStack.isHidden = true
            self.bpStack.isHidden = false
        }else{
            self.prnStack.isHidden = true
            self.bpStack.isHidden = false
            self.lblType.text = self.medication?.medicationType
            self.lblSupport.text = self.medication?.medicationSupport
            self.lblQuantity.text = self.medication?.quantityEachDose?.description
            self.lblRoute.text = self.medication?.medicationRouteName
            self.lblFrequancy.text = self.medication?.timeFrame
        }
        
        
        self.lblStatus.text = "Select"
        if let status = self.medication?.status, status.lowercased() != "scheduled" {
            self.lblStatus.text = status
        }
        self.btnSubmit.action = {
            if self.visit?.visitType == "Unscheduled" {
//                self.unschedulePRNSMedication_APICall()
                if self.medication?.medicationType == "PRN"{
                    if self.mediFlag {
                        self.updatePRNMedication_APICall1()

                    } else {
                        self.updateBPMedication_APICall1()
                    }
                }else if self.medication?.medicationType == "Scheduled"{
                    self.updateScheduleMedication_APICall1()
                }else{
                    self.updateBPMedication_APICall1()
                }
                if self.medication?.medicationType != "PRN"{
                    if self.lblStatus.text != "FullyTaken"{
                        self.AddAlert_APICall1()
                    }
                }
            } else {
                if self.medication?.medicationType == "PRN"{
                    if self.mediFlag {
                        self.updatePRNSMedication_APICall()
                    } else {
                        self.updatePRNMedication_APICall()
                    }
                }else if self.medication?.medicationType == "Scheduled"{
                    self.updateScheduleMedication_APICall()
                }else{
                    self.updateBPMedication_APICall()
                }
                if self.medication?.medicationType != "PRN"{
                    if self.lblStatus.text != "FullyTaken"{
                        self.AddAlert_APICall()
                    }
                }
            }
        }
        self.btnStatus.action = {
            let dropDown = DropDown()
            dropDown.anchorView = self.btnStatus // Attach dropdown to button
            dropDown.dataSource = ["FullyTaken","Prepared & Left Out","Not Taken","Missing Medication","Destroyed","Self Administered","Not Observed","Refused","Not Given","No Visit","Other","Partially Taken"]
            dropDown.direction = .bottom // Show dropdown below the button
            UserDefaults.standard.set(true, forKey: "sep")
            UserDefaults.standard.synchronize()
            dropDown.selectionAction = { (index: Int, item: String) in
                self.lblStatus.text = item
            }
            dropDown.show()
        }
        self.btnClose.action = {
            self.dismiss(animated: true)
        }
        self.btnClose1.action = {
            self.dismiss(animated: true)
        }
        
        if let array =  medication?.body_map_image_url, array.count > 0 {
            for index in 0...(array.count - 1) {

                self.createRow(title: medication?.body_part_names?[index], image: array[index])
            }
        }
    }
    
    func createRow(title: String?, image: String?) {
        let titleLabel = UILabel()
        titleLabel.text = title
//        titleLabel.textAlignment =
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.robotoSlab(.regular, size: 13)
        //RobotoSlabFont(size: 13, weight: .Regular)
        titleLabel.textColor = .black
//        titleLabel.widthAnchor.constraint(equalToConstant: self.visit.frame.width/2.2).isActive = true
        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true

        imageStackView.addArrangedSubview(titleLabel)
        
        let imageView = UIImageView()
        imageView.sd_setImage(with: URL(string: image ?? ""),
                              placeholderImage: UIImage(named: "logo1"))
        imageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true
        var width: CGFloat = self.view.frame.width - 40
        let wd = imageStackView.frame.width
        if wd > 40 {
            width = wd
        }
        imageView.widthAnchor.constraint(equalToConstant: width).isActive = true

//        titleLabel.textAlignment =
//        titleLabel.numberOfLines = 0
//        titleLabel.font = UIFont.RobotoSlabFont(size: 13, weight: .Regular)
//        titleLabel.textColor = .black
        imageStackView.addArrangedSubview(imageView)
    }
}
extension AddEditMedicationViewController{
    private func updatePRNMedication_APICall() {
        
        CustomLoader.shared.showLoader(on: self.view)

        let params = [APIParameters.Medication.clientId: self.medication?.clientID ?? "",
                      APIParameters.Medication.medicationId: self.medication?.medicationID ?? "",
                      APIParameters.Medication.prnId: self.medication?.prnID ?? "",
                      APIParameters.Medication.dosePer: self.medication?.dosePer ?? "",
                      APIParameters.Medication.doses: self.medication?.doses ?? "",
                      APIParameters.Medication.timeFrame: self.medication?.timeFrame ?? "",
                      APIParameters.Medication.prnOffered: self.medication?.prnOffered ?? "",
                      APIParameters.Medication.prnBeGiven: self.medication?.prnBeGiven ?? "",
                      APIParameters.Medication.visitDetailsId: self.visit?.visitDetailsID ?? "",
                      APIParameters.Medication.userId: UserDetails.shared.user_id,
                      APIParameters.Medication.carerNotes: self.txtView.text ?? "",
                      APIParameters.Medication.status: self.lblStatus.text ?? "",
                      APIParameters.Medication.medicationTime: "",
                      APIParameters.Medication.createdAt: convertDateToString(date: Date(),
                                                                              format: "yyyy-MM-dd HH:mm:ss",
                                                                              timeZone: TimeZone(identifier: "Europe/London"))
        ] as [String : Any]
        
        
        WebServiceManager.sharedInstance.callAPI(apiPath:visit?.visitType == "Unscheduled" ? .unSchedulemedicationPRNDetail : .medicationPRNDetails, method: .post, params: params,isAuthenticate: true, model: CommonRespons<[VisitMedicationModel]>.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        self?.updateHandler?()
                        self?.dismiss(animated: true)
                    }else{
                        self?.view.makeToast(data.message ?? "")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {[weak self] in
                    self?.view.makeToast(error.localizedDescription)
                }
            }
        }
    }
    private func updatePRNMedication_APICall1() {
        
        CustomLoader.shared.showLoader(on: self.view)

        let params = [APIParameters.Medication.clientId: self.medication?.clientID ?? "",
                      APIParameters.Medication.medicationId: self.medication?.medicationID ?? "",
                      APIParameters.Medication.prnId: self.medication?.prnID ?? "",
                      APIParameters.Medication.dosePer: self.medication?.dosePer ?? "",
                      APIParameters.Medication.doses: self.medication?.doses ?? "",
                      APIParameters.Medication.timeFrame: self.medication?.timeFrame ?? "",
                      APIParameters.Medication.prnOffered: self.medication?.prnOffered ?? "",
                      APIParameters.Medication.prnBeGiven: self.medication?.prnBeGiven ?? "",
                      APIParameters.Medication.visitDetailsId: self.visit?.visitDetailsID ?? "",
                      APIParameters.Medication.userId: UserDetails.shared.user_id,
                      APIParameters.Medication.carerNotes: self.txtView.text ?? "",
                      APIParameters.Medication.status: self.lblStatus.text ?? "",
                      APIParameters.Medication.medicationTime: "",
                      APIParameters.Medication.createdAt: convertDateToString(date: Date(),
                                                                              format: "yyyy-MM-dd HH:mm:ss",
                                                                              timeZone: TimeZone(identifier: "Europe/London"))
        ] as [String : Any]
        
        
        WebServiceManager.sharedInstance.callAPI(apiPath: .unSchedulemedicationPRNDetail,
                                                 method: .post,
                                                 params: params,
                                                 isAuthenticate: true,
                                                 model: CommonRespons<[VisitMedicationModel]>.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        self?.updateHandler?()
                        self?.dismiss(animated: true)
                    }else{
                        self?.view.makeToast(data.message ?? "")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {[weak self] in
                    self?.view.makeToast(error.localizedDescription)
                }
            }
        }
    }

    private func updateScheduleMedication_APICall() {
        
        CustomLoader.shared.showLoader(on: self.view)

        let params = [APIParameters.Medication.carerNotes: self.txtView.text ?? "",
                      APIParameters.Medication.status: self.lblStatus.text ?? "",
                      "scheduled_outcome": "1"
        ] as [String : Any]
    
        WebServiceManager.sharedInstance.callAPI(apiPath: .medicationScheduledDetails(scheduleId: (self.medication?.scheduledDetailsID ?? "").description), method: .put, params: params,isAuthenticate: true, model: CommonRespons<[VisitMedicationModel]>.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        self?.updateHandler?()
                        self?.dismiss(animated: true)
                    }else{
                        self?.view.makeToast(data.message ?? "")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {[weak self] in
                    self?.view.makeToast(error.localizedDescription)
                }
            }
        }
    }
    private func updateScheduleMedication_APICall1() {
        
        CustomLoader.shared.showLoader(on: self.view)

        let params = [APIParameters.Medication.carerNotes: self.txtView.text ?? "",
                      APIParameters.Medication.status: self.lblStatus.text ?? "",
                      "scheduled_outcome": "1"
        ] as [String : Any]
    
        WebServiceManager.sharedInstance.callAPI(apiPath: .medicationScheduledDetails(scheduleId: (self.medication?.scheduledDetailsID ?? "").description), method: .put, params: params,isAuthenticate: true, model: CommonRespons<[VisitMedicationModel]>.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        self?.updateHandler?()
                        self?.dismiss(animated: true)
                    }else{
                        self?.view.makeToast(data.message ?? "")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {[weak self] in
                    self?.view.makeToast(error.localizedDescription)
                }
            }
        }
    }

    private func updatePRNSMedication_APICall() {
        
        CustomLoader.shared.showLoader(on: self.view)

        let params = [APIParameters.Medication.carerNotes: self.txtView.text ?? "",
                      APIParameters.Medication.status: self.lblStatus.text ?? ""
        ] as [String : Any]


        WebServiceManager.sharedInstance.callAPI(apiPath: .medicationPrnDetails(cId: (self.medication?.prnDetailsID ?? "").description),
                                                 method: .get,
                                                 params: params,
                                                 isAuthenticate: true,
                                                 model: CommonRespons<[VisitMedicationModel]>.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        self?.updateHandler?()
                        self?.dismiss(animated: true)
                    }else{
                        self?.view.makeToast(data.message ?? "")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {[weak self] in
                    self?.view.makeToast(error.localizedDescription)
                }
            }
        }
    }
    private func updatePRNSMedication_APICall1() {
        
        CustomLoader.shared.showLoader(on: self.view)

        let params = [APIParameters.Medication.carerNotes: self.txtView.text ?? "",
                      APIParameters.Medication.status: self.lblStatus.text ?? ""
        ] as [String : Any]


        WebServiceManager.sharedInstance.callAPI(apiPath: .medicationPrnDetails(cId: (self.medication?.prnDetailsID ?? "").description),
                                                 method: .get,
                                                 params: params,
                                                 isAuthenticate: true,
                                                 model: CommonRespons<[VisitMedicationModel]>.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        self?.updateHandler?()
                        self?.dismiss(animated: true)
                    }else{
                        self?.view.makeToast(data.message ?? "")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {[weak self] in
                    self?.view.makeToast(error.localizedDescription)
                }
            }
        }
    }


    private func unschedulePRNSMedication_APICall() {
        
        CustomLoader.shared.showLoader(on: self.view)

        let params = [APIParameters.Medication.carerNotes: self.txtView.text ?? "",
                      APIParameters.Medication.status: self.lblStatus.text ?? "",
                     APIParameters.Medication.clientId : visit?.clientID ?? "",
                      "data" : visit?.visitDate ?? ""]

        WebServiceManager.sharedInstance.callAPI(apiPath: .unSchedulemedicationPRNDetail,
                                                 method: .put,
                                                 params: params,
                                                 isAuthenticate: true,
                                                 model: CommonRespons<[VisitMedicationModel]>.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        self?.updateHandler?()
                        self?.dismiss(animated: true)
                    }else{
                        self?.view.makeToast(data.message ?? "")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {[weak self] in
                    self?.view.makeToast(error.localizedDescription)
                }
            }
        }
    }

    
    private func updateBPMedication_APICall() {
        
        CustomLoader.shared.showLoader(on: self.view)

        let params = [APIParameters.Medication.carerNotes: self.txtView.text ?? "",
                      APIParameters.Medication.status: self.lblStatus.text ?? "",
                      "blister_pack_outcome": "1"
        ] as [String : Any]

        WebServiceManager.sharedInstance.callAPI(apiPath: .medicationBPDetails(bpId: (self.medication?.blisterPackDetailsID ?? "").description),
                                                 method: .put,
                                                 params: params,
                                                 isAuthenticate: true,
                                                 model: CommonRespons<[VisitMedicationModel]>.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        self?.updateHandler?()
                        self?.dismiss(animated: true)
                    }else{
                        self?.view.makeToast(data.message ?? "")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {[weak self] in
                    self?.view.makeToast(error.localizedDescription)
                }
            }
        }
    }
    private func updateBPMedication_APICall1() {
        
        CustomLoader.shared.showLoader(on: self.view)

        let params = [APIParameters.Medication.carerNotes: self.txtView.text ?? "",
                      APIParameters.Medication.status: self.lblStatus.text ?? "",
                      "blister_pack_outcome": "1"
        ] as [String : Any]

        WebServiceManager.sharedInstance.callAPI(apiPath: .medicationBPDetails(bpId: (self.medication?.blisterPackDetailsID ?? "").description),
                                                 method: .put,
                                                 params: params,
                                                 isAuthenticate: true,
                                                 model: CommonRespons<[VisitMedicationModel]>.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        self?.updateHandler?()
                        self?.dismiss(animated: true)
                    }else{
                        self?.view.makeToast(data.message ?? "")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {[weak self] in
                    self?.view.makeToast(error.localizedDescription)
                }
            }
        }
    }

    private func AddAlert_APICall() {
    
        var params = [APIParameters.Medication.clientId: self.visit?.clientID ?? "",
                      APIParameters.Medication.alert_type: "Medication \(self.lblStatus.text ?? "")",
                      APIParameters.Medication.alert_status: "Action Required",
                      APIParameters.Medication.createdAt: convertDateToString(date: Date(), format: "yyyy-MM-dd HH:mm:ss",
                                                                              timeZone: TimeZone(identifier: "Europe/London"))
        ] as [String : Any]
        if let scheduledID = self.medication?.scheduledID {
            params[APIParameters.Medication.scheduleId] = scheduledID
        }
        if let medicationID = self.medication?.medicationID{
            params[APIParameters.Medication.blister_pack_id] = medicationID
        }
        if let visitDetailsID = self.medication?.visitDetailsID?.value {
            params[APIParameters.Medication.visitDetailsId] = visitDetailsID
        }
        
        WebServiceManager.sharedInstance.callAPI(apiPath: .addMedicationAlertDetails,
                                                 method: .post,
                                                 params: params,
                                                 isAuthenticate: true,
                                                 model: CommonRespons<[String:CodableValue]>.self) { response, successMsg in
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        self?.updateHandler?()
                        self?.dismiss(animated: true)
                    }else{
                        self?.view.makeToast(data.message ?? "")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {[weak self] in
                    self?.view.makeToast(error.localizedDescription)
                }
            }
        }
    }

    private func AddAlert_APICall1() {
    
        var params = [APIParameters.Medication.clientId: self.visit?.clientID ?? "",
                      APIParameters.Medication.alert_type: "Medication \(self.lblStatus.text ?? "")",
                      APIParameters.Medication.alert_status: "Action Required",
                      APIParameters.Medication.createdAt: convertDateToString(date: Date(), format: "yyyy-MM-dd HH:mm:ss",
                                                                              timeZone: TimeZone(identifier: "Europe/London"))
        ] as [String : Any]
        if let scheduledID = self.medication?.scheduledID {
            params[APIParameters.Medication.scheduleId] = scheduledID
        }
        if let medicationID = self.medication?.medicationID{
            params[APIParameters.Medication.blister_pack_id] = medicationID
        }
        if let visitDetailsID = self.medication?.visitDetailsID?.value {
            params[APIParameters.Medication.visitDetailsId] = visitDetailsID
        }
        
        WebServiceManager.sharedInstance.callAPI(apiPath: .addMedicationAlertDetails,
                                                 method: .post,
                                                 params: params,
                                                 isAuthenticate: true,
                                                 model: CommonRespons<[String:CodableValue]>.self) { response, successMsg in
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        self?.updateHandler?()
                        self?.dismiss(animated: true)
                    }else{
                        self?.view.makeToast(data.message ?? "")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {[weak self] in
                    self?.view.makeToast(error.localizedDescription)
                }
            }
        }
    }

}
