//
//  UpdateToDoStatusVC.swift
//  CareEsteem
//
//  Created by Gaurav Agnihotri on 06/08/25.
//

import UIKit

class UpdateToDoStatusVC: UIViewController {

    @IBOutlet weak var main_view: AGView!
    @IBOutlet weak var lbl_heading: UILabel!
    @IBOutlet weak var lbl_addNotes: UILabel!
    @IBOutlet weak var txtView: AGTextView!
    @IBOutlet weak var btnNotComplete: AGButton!
    @IBOutlet weak var btnComplete: AGButton!
    @IBOutlet weak var btnClose: AGButton!
    @IBOutlet weak var viewAddition: AGView!
    @IBOutlet weak var addNotesHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewAddNotes: UIView!
    @IBOutlet weak var viewAddNotes1: UIView!
    
    
    var updateHandler:(()->Void)?
    var todo:VisitTodoModel?
    var visit:VisitsModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        main_view.layer.cornerRadius = 15
        main_view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        main_view.clipsToBounds = true
        
        self.lbl_heading.text = self.todo?.todoName
        self.lbl_addNotes.text = self.todo?.additionalNotes
        if self.todo?.additionalNotes == "" {
            self.viewAddNotes.isHidden = true
            self.viewAddNotes1.isHidden = true
            print("hide")
        }
        else {
            self.viewAddNotes.isHidden = false
            self.viewAddNotes1.isHidden = false
            print("show")
        }
        
       // self.viewAddition.isHidden = (self.todo?.additionalNotes ?? "") == ""
        self.txtView.text = self.todo?.carerNotes ?? ""
       // self.lblStatus.text = (self.todo?.todoOutcome ?? "")
        if (self.todo?.todoOutcome ?? "") == "Not Completed"{
          //  self.viewStatus.isHidden = true
        }else if (self.todo?.todoOutcome ?? "") == "Completed"{
         //   self.viewStatus.isHidden = true
        }else{
         //   self.viewStatus.isHidden = true
        }
        
        self.btnComplete.action = {
            self.updateStatus_APICall(todo_outcome: 1)
        }
        self.btnNotComplete.action = {
            self.updateStatus_APICall(todo_outcome: 0)
            if (self.todo?.todoEssential ?? false == true){
                self.AddAlert_APICall()
            }
        }
        self.btnClose.action = {
            self.dismiss(animated: true)
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        main_view.frame = CGRect(
            x: 0,
            y: self.view.frame.height * 0.3,
            width: self.view.frame.width,
            height: self.view.frame.height * 0.7
        )
    }
}
 extension UpdateToDoStatusVC{
    private func updateStatus_APICall(todo_outcome:Int) {
        
        CustomLoader.shared.showLoader(on: self.view)

        let params = [APIParameters.ToDo.carerNotes: self.txtView.text ?? "",
                      APIParameters.ToDo.todoOutcome: todo_outcome
        ] as [String : Any]

        WebServiceManager.sharedInstance.callAPI(apiPath: .editVisitTodoDetails(todoId: (self.todo?.todoDetailsID ?? "").description), method: .put, params: params,isAuthenticate: true, model: CommonRespons<[String: CodableValue]>.self) { response, successMsg in
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

        var params = [APIParameters.ToDo.clientId: self.visit?.clientID ?? 0,
                      APIParameters.ToDo.alert_type: "To Do Notcompleted",
                      APIParameters.ToDo.alert_status: "Action Required",
                      APIParameters.ToDo.createdAt: convertDateToString(date: Date(), format: "yyyy-MM-dd HH:mm:ss",
                                                                        timeZone: TimeZone(identifier: "Europe/London"))
        ] as [String : Any]
        if let todoDetailsID = self.todo?.todoDetailsID{
            params[APIParameters.ToDo.todo_details_id] = todoDetailsID
            params["visit_details_id"] = todoDetailsID
        }
        if let visitDetailsID = self.visit?.visitDetailsID{
            params[APIParameters.ToDo.visitDetailsId] = visitDetailsID
            params["visit_details_id"] = visitDetailsID

        }
        WebServiceManager.sharedInstance.callAPI(apiPath: .addTodoAlertDetails, method: .post, params: params,isAuthenticate: true, model: CommonRespons<[VisitTodoModel]>.self) { response, successMsg in
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
