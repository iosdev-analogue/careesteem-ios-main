//
//  AddEditUnscheduleVisitNotesViewController.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 10/03/25.
//

import UIKit

class AddEditUnscheduleVisitNotesViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnClose: AGButton!
    @IBOutlet weak var txtVisitNote: AGTextView!
    @IBOutlet weak var btnSubmit: AGButton!
    
    var updateHandler:(()->Void)?
    var visitNotes:UnscheduleNotesModel?
    var visitDetaiID:String?
    var isEdit:Bool = false
    
    var selectedType:VisitDetailType = .visitnote
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.isEdit{
            if self.selectedType == .todo{
                self.txtVisitNote.text = self.visitNotes?.todoNotes
            }else if self.selectedType == .medication{
                self.txtVisitNote.text = self.visitNotes?.medicationNotes
            }else if self.selectedType == .visitnote{
                self.txtVisitNote.text = self.visitNotes?.visitNotes
            }
        }
        self.btnSubmit.action = {
            if self.isEdit{
                if self.selectedType == .todo{
                    self.updateVisiteTodo_APICall()
                }else if self.selectedType == .medication{
                    self.addVisiteMedication_APICall()
                }else if self.selectedType == .visitnote{
                    self.updateVisiteNotes_APICall()
                }
            }else{
                if self.selectedType == .todo{
//                    self.addVisiteTodo_APICall()
                }else if self.selectedType == .medication{
                    self.updateVisiteMedication_APICall()
                }else if self.selectedType == .visitnote{
                    self.addVisiteNotes_APICall()
                }
            }
        }
        self.btnClose.action = {
            self.dismiss(animated: true)
        }
    }
}


// MARK: API Call
extension AddEditUnscheduleVisitNotesViewController {
    
//    private func addVisiteTodo_APICall() {
//        return
//        CustomLoader.shared.showLoader(on: self.view)
//
//        let params = [APIParameters.UnscheduledVisits.visitDetailsId: self.visitDetaiID ?? 0,
//                      APIParameters.UnscheduledVisits.todoNotes: self.txtVisitNote.text ?? "",
//                      APIParameters.UnscheduledVisits.todoUserId: UserDetails.shared.user_id,
//                      APIParameters.UnscheduledVisits.todoCreatedAt: convertDateToString(date: Date(), format: "yyyy-MM-dd HH:mm:ss",timeZone: TimeZone(identifier: "Europe/London"))
//        ] as [String : Any]
//
//        WebServiceManager.sharedInstance.callAPI(apiPath: .addTodoDetails, method: .post, params: params,isAuthenticate: true, model: CommonRespons<[VisitNotesModel]>.self) { response, successMsg in
//            CustomLoader.shared.hideLoader()
//            switch response {
//            case .success(let data):
//                DispatchQueue.main.async {[weak self] in
//                    if data.statusCode == 200{
//                        self?.updateHandler?()
//                        self?.dismiss(animated: true)
//                    }else{
//                        self?.view.makeToast(data.message ?? "")
//                    }
//                }
//            case .failure(let error):
//                DispatchQueue.main.async {[weak self] in
//                    self?.view.makeToast(error.localizedDescription)
//                }
//            }
//        }
//    }
    private func updateVisiteTodo_APICall() {
        
        CustomLoader.shared.showLoader(on: self.view)

        let params = [APIParameters.UnscheduledVisits.visitDetailsId: self.visitDetaiID ?? 0,
                      APIParameters.UnscheduledVisits.todoNotes: self.txtVisitNote.text ?? "",
                      APIParameters.UnscheduledVisits.todoUserId: UserDetails.shared.user_id,
                      APIParameters.UnscheduledVisits.todoUpdatedAt: convertDateToString(date: Date(),
                                                                                         format: "yyyy-MM-dd HH:mm:ss",
                                                                                         timeZone: TimeZone(identifier: "Europe/London"))
        ] as [String : Any]
        
        WebServiceManager.sharedInstance.callAPI(apiPath: .updateTodoDetails(todoId: (self.visitNotes?.id ?? "").description), method: .put, params: params,isAuthenticate: true, model: CommonRespons<[VisitNotesModel]>.self) { response, successMsg in
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
    
    private func addVisiteMedication_APICall() {
        
        CustomLoader.shared.showLoader(on: self.view)

        let params = [APIParameters.UnscheduledVisits.visitDetailsId: self.visitDetaiID ?? 0,
                      APIParameters.UnscheduledVisits.medicationNotes: self.txtVisitNote.text ?? "",
                      APIParameters.UnscheduledVisits.medicationUserId: UserDetails.shared.user_id,
                      APIParameters.UnscheduledVisits.medicationCreatedAt: convertDateToString(date: Date(), format: "yyyy-MM-dd HH:mm:ss",timeZone: TimeZone(identifier: "Europe/London"))
        ] as [String : Any]

        WebServiceManager.sharedInstance.callAPI(apiPath: .addMedicationDetails, method: .post, params: params,isAuthenticate: true, model: CommonRespons<[VisitNotesModel]>.self) { response, successMsg in
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
    private func updateVisiteMedication_APICall() {
        
        CustomLoader.shared.showLoader(on: self.view)

        let params = [APIParameters.UnscheduledVisits.visitDetailsId: self.visitDetaiID ?? 0,
                      APIParameters.UnscheduledVisits.medicationNotes: self.txtVisitNote.text ?? "",
                      APIParameters.UnscheduledVisits.medicationUserId: UserDetails.shared.user_id,
                      APIParameters.UnscheduledVisits.medicationUpdatedAt: convertDateToString(date: Date(), format: "yyyy-MM-dd HH:mm:ss",
                                                                                               timeZone: TimeZone(identifier: "Europe/London"))
        ] as [String : Any]
        
        WebServiceManager.sharedInstance.callAPI(apiPath: .editMedicationDetails(medicationId: (self.visitNotes?.id ?? "")), method: .put, params: params,isAuthenticate: true, model: CommonRespons<[VisitNotesModel]>.self) { response, successMsg in
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
    
    private func addVisiteNotes_APICall() {
        
        CustomLoader.shared.showLoader(on: self.view)

        let params = [APIParameters.UnscheduledVisits.visitDetailsId: self.visitDetaiID ?? 0,
                      APIParameters.UnscheduledVisits.visitNotes: self.txtVisitNote.text ?? "",
                      APIParameters.UnscheduledVisits.visitUserId: UserDetails.shared.user_id,
                      APIParameters.UnscheduledVisits.createdbyUserid: UserDetails.shared.user_id,
                      APIParameters.UnscheduledVisits.visitCreatedAt: convertDateToString(date: Date(), format: "yyyy-MM-dd HH:mm:ss",
                                                                                          timeZone: TimeZone(identifier: "Europe/London"))
        ] as [String : Any]
        
    
        WebServiceManager.sharedInstance.callAPI(apiPath: .addUnscheduledVisitNotesDetails, method: .post, params: params,isAuthenticate: true, model: CommonRespons<[VisitNotesModel]>.self) { response, successMsg in
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
    private func updateVisiteNotes_APICall() {
        
        CustomLoader.shared.showLoader(on: self.view)
        let unscheduledVisits = APIParameters.UnscheduledVisits.self

        let params = [unscheduledVisits.visitDetailsId: self.visitDetaiID ?? 0,
                      unscheduledVisits.visitNotes: self.txtVisitNote.text ?? "",
                      unscheduledVisits.visitUserId: UserDetails.shared.user_id,
                      unscheduledVisits.visitUpdatedAt: convertDateToString(date: Date(),
                                                                            format: "yyyy-MM-dd HH:mm:ss",
                                                                            timeZone: TimeZone(identifier: "Europe/London"))
        ] as [String : Any]
        
        WebServiceManager.sharedInstance.callAPI(apiPath: .updateUnscheduledVisitNotesDetails(visitNotesId: self.visitNotes?.id ?? ""), method: .put, params: params,isAuthenticate: true, model: CommonRespons<[VisitNotesModel]>.self) { response, successMsg in
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
}
