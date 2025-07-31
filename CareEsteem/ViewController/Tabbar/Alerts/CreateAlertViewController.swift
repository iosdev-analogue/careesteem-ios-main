//
//  CreateAlertViewController.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 10/03/25.
//

import UIKit
import DropDown

class CreateAlertViewController: UIViewController {

    @IBOutlet weak var lblClientName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblSeverityOfConcern: UILabel!
    @IBOutlet weak var txtConcernDetail: UITextView!

    @IBOutlet weak var btnClientName: AGButton!
    @IBOutlet weak var btnVisitTime: AGButton!
    @IBOutlet weak var btnSeverityOfConcern: AGButton!
    @IBOutlet weak var btnDisable: AGButton!
    @IBOutlet weak var btnEnable: AGButton!
    @IBOutlet weak var btnSave: AGButton!
    @IBOutlet weak var btnCancel: AGButton!
    @IBOutlet weak var clientDropDownHeightConstraint: NSLayoutConstraint!
    var bodyPartList:[BodyPartModel] = []
    var clientList:[ClientNameModel] = []
    var visitList:[VisitsModel] = []
    
    var selectedClient:ClientNameModel?
    var selectedVisit:VisitsModel?
    
    var addedBodyPart:[SelectedBodyPart] = []
    
    @IBOutlet weak var tableView: AGTableView!
    @IBOutlet weak var selectedTableView: AGTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.bodyPartList = [
            BodyPartModel(name: "Body", list: [
                PartItem(name: "Body Front", image: "comp_body_front"),
                PartItem(name: "Body Back", image: "comp_body_back")
            ],isExpand:false),
            BodyPartModel(name: "Face", list: [
                PartItem(name: "Face Front", image: "comp_face_front"),
                PartItem(name: "Face Back", image: "comp_face_back"),
            ],isExpand:false),
            BodyPartModel(name: "Hand", list: [
                PartItem(name:  "Right Front", image: "comp_hand_right_front"),
                PartItem(name:  "Right Back", image: "comp_hand_right_back"),
                PartItem(name:  "Left Front", image: "comp_hand_left_front"),
                PartItem(name:  "Left Back", image: "comp_hand_left_back"),
            ],isExpand:false),
            BodyPartModel(name: "Pelvis", list: [
                PartItem(name:  "Pelvis Front", image: "comp_pelvis_front"),
                PartItem(name:  "Pelvis Back", image: "comp_pelvis_back"),
            ],isExpand:false),
            BodyPartModel(name: "Feet", list: [
                PartItem(name: "Right Front", image: "comp_feet_right_front"),
                PartItem(name: "Right Back", image: "comp_feet_right_back"),
                PartItem(name: "Right Heel", image: "comp_feet_right_heel"),
                PartItem(name: "Left Front", image: "comp_feet_left_front"),
                PartItem(name: "Left Back", image: "comp_feet_left_back"),
                PartItem(name: "Left Heel", image: "comp_feet_left_heel"),
            ],isExpand:false)
        ]

        self.getAlertDetail_APICall()
        
        self.btnDisable.isSelected = true
        self.btnDisable.setImage(UIImage(systemName: "button.programmable"), for: .selected)
        self.btnEnable.isSelected = false
        self.btnEnable.setImage(UIImage(systemName: "button.programmable"), for: .selected)
        self.selectedTableView.isHidden = true
        self.tableView.isHidden = true
        
        self.btnClientName.action = {
            let dropDown = DropDown()
            dropDown.anchorView = self.btnClientName // Attach dropdown to button
            dropDown.separatorColor = .green
            dropDown.dataSource = self.clientList.map{$0.clientName ?? ""}
            dropDown.direction = .bottom // Show dropdown below the button
            dropDown.selectionAction = { (index: Int, item: String) in
                self.selectedClient = self.clientList[index]
                self.lblClientName.text = item
                self.selectedVisit = self.visitList.first(where:{ v in
                    v.clientID == self.selectedClient?.clientID
                })
                self.lblTime.text = "\(self.selectedVisit?.plannedStartTime ?? "") - \(self.selectedVisit?.plannedEndTime ?? "")"
            }
            self.clientDropDownHeightConstraint.constant = CGFloat(self.clientList.count  < 5 ? self.clientList.count * 50 :  300) + 50
            dropDown.cancelAction = {
                self.clientDropDownHeightConstraint.constant = 0
            }
            dropDown.show()
        }
        self.btnVisitTime.action = {
            let dropDown = DropDown()
            dropDown.anchorView = self.btnVisitTime // Attach dropdown to button
            dropDown.dataSource = self.visitList.filter({ v in
                v.clientID == self.selectedClient?.clientID
            }).map{"\($0.plannedStartTime ?? "") - \($0.plannedEndTime ?? "")"}
            dropDown.direction = .any // Show dropdown below the button
            dropDown.selectionAction = { (index: Int, item: String) in
                self.selectedVisit = self.visitList[index]
                self.lblTime.text = item
            }
            dropDown.show()
        }
        self.btnSeverityOfConcern.action = {
            let dropDown = DropDown()
            dropDown.separatorColor = .green
            dropDown.anchorView = self.btnSeverityOfConcern // Attach dropdown to button
            dropDown.dataSource = ["Low","Medium","High"]
            dropDown.direction = .any // Show dropdown below the button
            dropDown.selectionAction = { (index: Int, item: String) in
                self.lblSeverityOfConcern.text = item
            }
            dropDown.show()
        }
        
        self.btnDisable.action = {
            self.btnDisable.isSelected = true
            self.btnEnable.isSelected = false
            self.selectedTableView.isHidden = true
            self.tableView.isHidden = true
        }
        self.btnEnable.action = {
            self.btnDisable.isSelected = false
            self.btnEnable.isSelected = true
            self.selectedTableView.isHidden = self.addedBodyPart.isEmpty
            self.tableView.isHidden = false
        }
        self.btnSave.action = {
            if self.selectedClient == nil{
                self.view.makeToast("Please select the client")
            }else if self.selectedVisit == nil{
                self.view.makeToast("Please select the visit")
            }else if (self.txtConcernDetail.text ?? "") == ""{
                self.view.makeToast("Please enter the Concern Details")
            }else{
                self.createAlert_APICall()
            }
        }
        self.btnCancel.action = {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
extension CreateAlertViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int{
        if tableView == self.tableView{
            return self.bodyPartList.count
        }else{
            return 1
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView{
            if self.bodyPartList[section].isExpand ?? false{
                return self.bodyPartList[section].list?.count ?? 0
            }else{
                return 0
            }
        }else{
            return addedBodyPart.count
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.tableView{
            return 50
        }else{
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        if tableView == self.tableView{
            let cell = tableView.dequeueReusableCell(withClassIdentifier: BodyPartSectionTableCell.self)
            cell.setupData(model: self.bodyPartList[section])
            cell.clickHandler = {
                self.bodyPartList[section].isExpand = !(self.bodyPartList[section].isExpand ?? false)
                self.tableView.reloadData()
            }
            let view: AGView = cell.viewWithTag(1) as! AGView
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.1, execute: {
                if self.bodyPartList[section].isExpand ?? false {
                    view.roundCorners([.topLeft, .topRight], radius: 5)
                } else {
                    view.roundCorners([.allCorners], radius: 5)
                }
            })

            self.tableView.layoutSubviews()
            return cell
        }else{
            return nil
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView{
            let cell = tableView.dequeueReusableCell(withClassIdentifier: MyCareItemTableViewCell.self,for: indexPath)
            cell.lblName.text = self.bodyPartList[indexPath.section].list?[indexPath.row].name
            if indexPath.row + 1 == self.bodyPartList[indexPath.section].list?.count {
                cell.bgView.addBottomLeftRightBordersWithRoundedCorners(borderColor: UIColor(named: "appGreen")!, borderWidth: 2, cornerRadius: 5)
            } else {
                cell.bgView.layer.sublayers?.removeAll(where: { $0.name == "customBorderLayer" })
                cell.bgView.addBottomLeftRightBordersWithRoundedCorners(borderColor: UIColor(named: "appGreen")!, borderWidth: 0, cornerRadius: 0)
                
                DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.1, execute: {[weak self] in
                    self?.addBottomBorderWithColor(cell.bgView, color: UIColor(named: "appGreen")!, width: 1)
                })
                cell.bgView.clipsToBounds = true
                DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.1, execute: {[weak self] in
                    self?.addLeftBorderWithColor(cell.bgView, color: UIColor(named: "appGreen")!, width: 1)
                    self?.addRightBorderWithColor(cell.bgView, color: UIColor(named: "appGreen")!, width: 1)
                })
            }
            if indexPath.row != 0 {
                cell.bgView.backgroundColor = .white
            }
            self.tableView.layoutSubviews()
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withClassIdentifier: BodyPartSelectedTableCell.self,for: indexPath)
            cell.setupData(model: self.addedBodyPart[indexPath.row])
            cell.clickHandler = {
                self.addedBodyPart.remove(at: indexPath.row)
                self.selectedTableView.isHidden = self.addedBodyPart.isEmpty
                self.selectedTableView.reloadData()
            }
            self.selectedTableView.layoutSubviews()
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if tableView == self.tableView{
            let vc = Storyboard.Alerts.instantiateViewController(withViewClass: EditImageViewController.self)
            vc.modalPresentationStyle = .overFullScreen
            vc.selectedImage = SelectedBodyPart(parent: self.bodyPartList[indexPath.section].name,name: self.bodyPartList[indexPath.section].list?[indexPath.row].name,image: self.bodyPartList[indexPath.section].list?[indexPath.row].image)
            vc.updatedHandler = { temp in
                if let t = temp{
                    self.addedBodyPart.append(t)
                    self.selectedTableView.isHidden = self.addedBodyPart.isEmpty
                    self.selectedTableView.reloadData()
                }
            }
                vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }else{
            
        }
    }
}


// MARK: API Call
extension CreateAlertViewController {
    
    private func getAlertDetail_APICall() {
        
        CustomLoader.shared.showLoader(on: self.view)
        let s = convertDateToString(date:Date(), format: "yyyy-MM-dd",timeZone: TimeZone(identifier: "Europe/London"))
       // s = "2025-02-03"
        WebServiceManager.sharedInstance.callAPI(apiPath: .getClientNameList(userId: UserDetails.shared.user_id),queryParams: [APIParameters.Visits.visitDate: s], method: .get, params: [:],isAuthenticate: true, model: CommonRespons<[ClientNameModel]>.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        self?.clientList = data.data ?? []
                        self?.selectedClient = self?.clientList.first
                        self?.lblClientName.text = self?.clientList.first?.clientName
                        self?.getVisiteList_APICall()
                    }else{
                       // self.view.makeToast(data.message ?? "")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {[weak self] in
                    self?.view.makeToast(error.localizedDescription)
                }
            }
        }
    }
    private func getVisiteList_APICall() {
        
        CustomLoader.shared.showLoader(on: self.view)
        let s = convertDateToString(date:Date(), format: "yyyy-MM-dd",timeZone: TimeZone(identifier: "Europe/London"))
       // s = "2025-02-03"
        WebServiceManager.sharedInstance.callAPI(apiPath: .getVisitList(userId: UserDetails.shared.user_id),queryParams: [APIParameters.Visits.visitDate: s], method: .get, params: [:],isAuthenticate: true, model: CommonRespons<[VisitsModel]>.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        self?.visitList = data.data ?? []
                        self?.selectedVisit = self?.visitList.first(where:{ v in
                            v.clientID == self?.selectedClient?.clientID
                        })
                        self?.lblTime.text = "\(self?.selectedVisit?.plannedStartTime ?? "") - \(self?.selectedVisit?.plannedEndTime ?? "")"
                    }else{
                       // self.view.makeToast(data.message ?? "")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {[weak self] in
                    self?.view.makeToast(error.localizedDescription)
                }
            }
        }
    }
    
    private func createAlert_APICall() {
        
        CustomLoader.shared.showLoader(on: self.view)
        
        var params = [APIParameters.Alerts.alertMessage: self.txtConcernDetail.text ?? "",
                      APIParameters.Alerts.clientId: self.selectedClient?.clientID ?? 0,
                      APIParameters.Alerts.userId: UserDetails.shared.user_id,
                      APIParameters.Alerts.visitDetailsId: self.selectedVisit?.visitDetailsID ?? "",
                      APIParameters.Alerts.severityOfConcern: self.lblSeverityOfConcern.text ?? "",
                      APIParameters.Alerts.concernDetails: self.txtConcernDetail.text ?? "",
                      APIParameters.Alerts.createdAt: convertDateToString(date: Date(),
                                                                          format: "yyyy-MM-dd HH:mm:ss",
                                                                          timeZone: TimeZone(identifier: "Europe/London"))
        ] as [String : Any]
        
        if self.btnEnable.isSelected && self.addedBodyPart.count > 0{
            params[APIParameters.Alerts.bodyPartType] = self.addedBodyPart.map{$0.parent ?? ""}.joined(separator: ",")
            params[APIParameters.Alerts.bodyPartNames] = self.addedBodyPart.map{$0.name ?? ""}.joined(separator: ",")
            params[APIParameters.Alerts.fileName] = self.addedBodyPart.map{$0.fileName ?? ""}.joined(separator: ",")
            params[APIParameters.Alerts.images] = self.addedBodyPart.map{$0.updatedImage ?? UIImage()}
        }else{
            params[APIParameters.Alerts.bodyPartType] = ""
            params[APIParameters.Alerts.bodyPartNames] = ""
            params[APIParameters.Alerts.fileName] = ""
            params[APIParameters.Alerts.images] = []
        }
        
        WebServiceManager.sharedInstance.imageUploadAPIRequest(url: .addAlert, method: .post, formFields: params, model: CommonRespons<[ClientNameModel]>.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        self?.navigationController?.popViewController(animated: true)
                        AppDelegate.shared.topViewController()?.view.makeToast(data.message ?? "")
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
    
    func addTopBorderWithColor(_ objView : UIView, color: UIColor, width: CGFloat) {
    let border = CALayer()
        border.name = "broderName"
    border.backgroundColor = color.cgColor
    border.frame = CGRect(x: 0, y: 0, width: objView.frame.size.width, height: width)
    objView.layer.addSublayer(border)
    }
    
    func addLeftBorderWithColor(_ objView : UIView, color: UIColor, width: CGFloat) {
    let border = CALayer()
        border.name = "broderName"
    border.backgroundColor = color.cgColor
    border.frame = CGRect(x: 0, y: 0, width: width, height: objView.frame.size.height)
    objView.layer.addSublayer(border)
    }
    
    func addRightBorderWithColor(_ objView : UIView, color: UIColor, width: CGFloat) {
    let border = CALayer()
        border.name = "broderName"
    border.backgroundColor = color.cgColor
    border.frame = CGRect(x: objView.frame.size.width - width, y: 0, width: width, height: objView.frame.size.height)
    objView.layer.addSublayer(border)
    }

    func addBottomBorderWithColor(_ objView : UIView, color: UIColor, width: CGFloat) {
        let border = CALayer()
//        objView.layer.sublayers?.removeAll(where: { $0.name == "customBorderLayer" || $0.name == "borderName" })
        border.name = "broderName"
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: objView.frame.size.height - width, width: objView.frame.size.width, height: width)
        objView.layer.addSublayer(border)
    }
    
    
}


extension UIView {
    func addBottomLeftRightBordersWithRoundedCorners(borderColor: UIColor, borderWidth: CGFloat, cornerRadius: CGFloat) {
        // Remove existing custom layers if needed
        self.layer.sublayers?.removeAll(where: { $0.name == "customBorderLayer" || $0.name == "borderName" })

        // Create path with bottom left & right corners rounded
        let path = UIBezierPath()
        let width = self.bounds.width
        let height = self.bounds.height

        path.move(to: CGPoint(x: 0, y: 0)) // Start at top-left (we won't draw top)
        path.addLine(to: CGPoint(x: 0, y: height - cornerRadius))
        path.addQuadCurve(to: CGPoint(x: cornerRadius, y: height),
                          controlPoint: CGPoint(x: 0, y: height))

        path.addLine(to: CGPoint(x: width - cornerRadius, y: height))
        path.addQuadCurve(to: CGPoint(x: width, y: height - cornerRadius),
                          controlPoint: CGPoint(x: width, y: height))

        path.addLine(to: CGPoint(x: width, y: 0)) // Up to top-right (no top border)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = borderColor.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = borderWidth
        shapeLayer.name = "customBorderLayer"

        self.layer.addSublayer(shapeLayer)
    }
}
