//
//  AddEditVisitNotesViewController.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 10/03/25.
//

import UIKit

class AddEditVisitNotesViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnClose: AGButton!
    @IBOutlet weak var txtVisitNote: AGTextView!
    @IBOutlet weak var btnSubmit: AGButton!
    @IBOutlet weak var btnCancel: AGButton!
    
    var updateHandler:(()->Void)?
    var visitNotes:VisitNotesModel?
    var visitDetaiID:String?
    var isEdit:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.isEdit{
            self.txtVisitNote.text = self.visitNotes?.visitNotes
        }
        
        btnCancel.action = {
            self.dismiss(animated: true)
        }
        
        self.btnSubmit.action = {
            if self.isEdit{
                self.updateVisiteNotes_APICall()
            }else{
                self.addVisiteNotes_APICall()
            }
        }
        self.btnClose.action = {
            self.dismiss(animated: true)
        }
    }
}


// MARK: API Call
extension AddEditVisitNotesViewController {
    
    private func addVisiteNotes_APICall() {
        
        CustomLoader.shared.showLoader(on: self.view)

        let params = [APIParameters.Visits.visit_details_id: self.visitDetaiID ?? 0,
                      APIParameters.Visits.visitNotes: self.txtVisitNote.text ?? "",
                      APIParameters.Visits.createdbyUserid: UserDetails.shared.user_id,
                      APIParameters.Visits.createdAt: convertDateToString(date: Date(), format: "yyyy-MM-dd HH:mm:ss",timeZone: TimeZone(identifier: "Europe/London"))
        ] as [String : Any]

        WebServiceManager.sharedInstance.callAPI(apiPath: .addVisitNotes, method: .post, params: params,isAuthenticate: true, model: CommonRespons<[VisitNotesModel]>.self) { response, successMsg in
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

        let params = [APIParameters.Visits.visit_details_id: self.visitDetaiID ?? "0",
                      APIParameters.Visits.visitNotes: self.txtVisitNote.text ?? "",
                      APIParameters.Visits.createdbyUserid: (self.visitNotes?.createdByUserID ?? "").description,
                      APIParameters.Visits.createdAt:self.visitNotes?.createdAt ?? "",
                      APIParameters.Visits.updatedbyUserid: UserDetails.shared.user_id,
                      APIParameters.Visits.updatedAt: convertDateToString(date: Date(), format: "yyyy-MM-dd HH:mm:ss",
                                                                          timeZone: TimeZone(identifier: "Europe/London"))
        ] as [String : Any]

        WebServiceManager.sharedInstance.callAPI(apiPath: .editVisitNotes(visitNotesId: (self.visitNotes?.id ?? "").description), method: .put, params: params,isAuthenticate: true, model: CommonRespons<[VisitNotesModel]>.self) { response, successMsg in
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

