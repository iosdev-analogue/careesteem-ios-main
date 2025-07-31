//
//  UpdateStatusViewController.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 14/03/25.
//

import UIKit

class UpdateStatusViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnClose: AGButton!
    @IBOutlet weak var btnComplete: AGButton!
    @IBOutlet weak var btnNotComplete: AGButton!
    @IBOutlet weak var txtView: AGTextView!
    
    @IBOutlet weak var viewAddition: UIView!
    
    @IBOutlet weak var lblToDo: UILabel!
    @IBOutlet weak var lblAdditional: UILabel!
    
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var viewStatus: UIView!
    
    var updateHandler:(()->Void)?
    var todo:VisitTodoModel?
    var visit:VisitsModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.lblTitle.text = self.todo?.todoName
//        self.lblToDo.text = self.todo?.todoName
        self.lblAdditional.text = self.todo?.additionalNotes
        
        self.viewAddition.isHidden = (self.todo?.additionalNotes ?? "") == ""
        self.txtView.text = self.todo?.carerNotes ?? ""
        self.lblStatus.text = (self.todo?.todoOutcome ?? "")
        if (self.todo?.todoOutcome ?? "") == "Not Completed"{
            self.viewStatus.isHidden = true
        }else if (self.todo?.todoOutcome ?? "") == "Completed"{
            self.viewStatus.isHidden = true
        }else{
            self.viewStatus.isHidden = true
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
}
extension UpdateStatusViewController{
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
