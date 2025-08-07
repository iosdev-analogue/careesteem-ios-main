//
//  ClientDetailViewController.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 08/03/25.
//

import UIKit

class ClientDetailViewController: UIViewController {
    @IBOutlet weak var aboutMeBtn: AGButton!
    @IBOutlet weak var careBtn: AGButton!
    @IBOutlet weak var planBtn: AGButton!

    @IBOutlet weak var myCareTableView: AGTableView!
    @IBOutlet weak var carePlanTableView: AGTableView!
    @IBOutlet weak var btnAboutMe: AGButton!
    @IBOutlet weak var btnCareNetwork: AGButton!
    @IBOutlet weak var btnCarePlan: AGButton!
    @IBOutlet weak var imgDropDownCareNetwork: UIImageView!
    @IBOutlet weak var imgDropDownCarePlan: UIImageView!
    var imageView: UIImageView!
    
    @IBOutlet weak var btnCreateUnschedule: AGButton!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var clientNameLbl: UILabel!
    var clientDetail:ClientDetailModel?
    var client:ClientModel?
    var list:[MyCustomListModel] = []
    var expendedIndex = -1
    var selectedType: ClientDetailType = .about
    var aboutList:[[MyPopupListModel]] = []
    var docArray: [Documents] = []
    
    @IBAction func docBtnaction(_ sender: Any) {
        if docArray.count == 0 {
            self.view.makeToast("No Document Found")
            return
        }
        let vc = Storyboard.Clients.instantiateViewController(withViewClass: DocumentsViewController.self)
        
        vc.titleStr = "Documents"
        vc.docArray = self.docArray
//        vc.modalPresentationStyle = ./*overFullScreen*/
        vc.modalPresentationStyle = .popover
        self.present(vc, animated: true)
    }
    enum ClientDetailType{
        case about
        case care
        case plan
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView = UIImageView.init(frame: CGRect(x: 0, y: 52, width: 10, height: 5))
        imageView.image = UIImage(named: "polygon")
        let scroll = self.view.viewWithTag(9)
        scroll?.addSubview(imageView)
        self.lblName.text = "About \(self.client?.fullName ?? "")"
        self.getClientDetail_APICall()
        self.getRiskDetail_APICall()
        self.getPlanCare_APICall()
        self.lblName.text = client?.fullName ?? ""
        if var components = client?.fullName?.components(separatedBy: " "), components.count > 1 {
            self.lblName.text = components.last
        }
        self.myCareTableView.isHidden = true
        self.carePlanTableView.isHidden = true
        aboutList = []
        aboutList = [[
            MyPopupListModel(title:"Date of Birth",value: self.clientDetail?.about?.dateOfBirth ?? ""),
            MyPopupListModel(title:"Age",value: (self.clientDetail?.about?.age?.value as? Int ?? 0).description),
            MyPopupListModel(title:"NHs No.",value: self.clientDetail?.about?.nhsNumber ?? ""),
            MyPopupListModel(title:"Gender",value: self.clientDetail?.about?.gender ?? ""),
            MyPopupListModel(title:"Religion",value: self.clientDetail?.about?.religion ?? ""),
            MyPopupListModel(title:"Marital Status",value: self.clientDetail?.about?.maritalStatus ?? ""),
            MyPopupListModel(title:"Ethnicity",value: self.clientDetail?.about?.ethnicity ?? "")]]
        self.btnAboutMe.action = {
            let vc = Storyboard.Clients.instantiateViewController(withViewClass: PopupAboutMeInfoViewController.self)
            vc.titleStr = "About \(self.client?.fullName ?? "")"
            vc.list = self.aboutList
            vc.transitioningDelegate = customTransitioningDelegate
            vc.modalPresentationStyle = .custom
            self.present(vc, animated: true)
        }
        
        self.aboutMeBtn.action = {
            self.selectedType = .about
            self.setData()
        }
        self.careBtn.action = {
            self.selectedType = .care
            self.setData()
        }
        self.planBtn.action = {
            self.selectedType = .plan
            self.setData()
        }
        planBtn.roundCorners([.topLeft, .topRight], radius: 10)
        careBtn.roundCorners([.topLeft, .topRight], radius: 10)
        aboutMeBtn.roundCorners([.topLeft, .topRight], radius: 10)

        self.selectedType = .about
        self.setData()
        getdocuments()
//        self.btnCareNetwork.action = {
//            if self.myCareTableView.isHidden{
//                self.imgDropDownCareNetwork.image = UIImage(systemName: "chevron.up")
//                self.myCareTableView.isHidden = false
//            }else{
//                self.imgDropDownCareNetwork.image = UIImage(systemName: "chevron.down")
//                self.myCareTableView.isHidden = true
//            }
//            
//        }
//        self.btnCarePlan.action = {
//            if self.carePlanTableView.isHidden{
//                self.imgDropDownCarePlan.image = UIImage(systemName: "chevron.up")
//                self.carePlanTableView.isHidden = false
//                self.carePlanTableView.layoutSubviews()
//            }else{
//                self.imgDropDownCarePlan.image = UIImage(systemName: "chevron.down")
//                self.carePlanTableView.isHidden = true
//            }
//        }
        self.btnCreateUnschedule.action = {
            let vc = Storyboard.Clients.instantiateViewController(withViewClass: PopupCreateUnchecduleViewController.self)
            vc.confirmHandler = {
                let vc = Storyboard.Visits.instantiateViewController(withViewClass: CheckinCheckoutViewController.self)
                vc.client = self.client
                vc.isCheckin = true
                AppDelegate.shared.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            }
            vc.transitioningDelegate = customTransitioningDelegate
            vc.modalPresentationStyle = .custom
            self.present(vc, animated: true)
        }
        
    }
    @IBAction func btnBackAction(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateImageViewFrame(btn: AGButton) {
        imageView.frame =  CGRect(x: (btn.frame.origin.x + btn.frame.width / 2 + 5), y: 52, width: 10, height: 5)
    }
    func setData() {
        if selectedType == .about {
            self.aboutList = [[ MyPopupListModel(title:"Gender",
                                                 value: self.clientDetail?.about?.gender ?? ""),
                                MyPopupListModel(title:"Religion",
                                                 value: self.clientDetail?.about?.religion ?? ""),
                                MyPopupListModel(title:"Ethnicity",
                                                 value: self.clientDetail?.about?.ethnicity ?? ""),
                                MyPopupListModel(title:"Name",
                                                 value: self.clientNameLbl.text ?? "name"),
                                MyPopupListModel(title:"Date of Birth",
                                                 value: self.clientDetail?.about?.dateOfBirth ?? ""),
                                MyPopupListModel(title:"Age",
                                                 value: (self.clientDetail?.about?.age?.value as? Int ?? 0).description),
                                MyPopupListModel(title:"NHS No.",
                                                 value: self.clientDetail?.about?.nhsNumber ?? ""),
                                MyPopupListModel(title:"Marital Status",
                                                 value: self.clientDetail?.about?.maritalStatus ?? "")]]
            self.setupSelected(view: aboutMeBtn)
            self.setupUnselected(view: planBtn)
            self.setupUnselected(view: careBtn)
            updateImageViewFrame(btn: aboutMeBtn)
            self.carePlanTableView.isHidden = false
            self.carePlanTableView.reloadData()
            self.myCareTableView.isHidden = true
            
        }else if selectedType == .care{
            self.setupSelected(view: careBtn)
            self.setupUnselected(view: aboutMeBtn)
            self.setupUnselected(view: planBtn)
            updateImageViewFrame(btn: careBtn)
            self.carePlanTableView.reloadData()
            self.myCareTableView.reloadData()

        }else if selectedType == .plan {
            self.setupSelected(view: planBtn)
            updateImageViewFrame(btn: planBtn)
            self.carePlanTableView.reloadData()
            self.myCareTableView.reloadData()
            self.setupUnselected(view: aboutMeBtn)
            self.setupUnselected(view: careBtn)
        }
    }
    
    func setupSelected(view:AGButton){
        view.backgroundColor = UIColor(named: "appGreen")
        view.setTitleColor(.white, for: .normal)
    }
    func setupUnselected(view:AGButton){
        view.backgroundColor = UIColor(named: "appBlue")?.withAlphaComponent(0.10) ?? .blue
        view.setTitleColor(UIColor(named: "appDarkText") ?? .gray, for: .normal)
    }
}
extension ClientDetailViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedType == .about {
            return min(aboutList.count, 1)
        }
        if selectedType == .care {
            return  (self.clientDetail?.myCareNetwork?.count ?? 0) + (expendedIndex == -1 ? 0 : 1)
        }else{
            return self.list.count
        }
        return 0;//self.list.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if selectedType == .about {
            let cell = tableView.dequeueReusableCell(withClassIdentifier: AboutStackTableViewCell.self,for: indexPath)
            cell.setupData(model: self.aboutList[indexPath.row], imageUrl: client?.profilePhoto)
            cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.width, bottom: 0, right: 0)
            return cell
        }
        if selectedType == .care {
            if !(expendedIndex != -1 && (indexPath.row == expendedIndex + 1)) {
                let cell = tableView.dequeueReusableCell(withClassIdentifier: MyCareItemTableViewCell.self,for: indexPath)
                var index = 0
                if expendedIndex == -1 {
                    index = indexPath.row
                } else {
                    index = indexPath.row > expendedIndex ? indexPath.row - 1 : indexPath.row
                }
                cell.lblName.text = self.clientDetail?.myCareNetwork?[index].occupationType
                let iv: UIImageView = cell.viewWithTag(2) as! UIImageView
                iv.image = indexPath.row == expendedIndex ? UIImage(named: "downArrow") : UIImage(named: "upArrow")
                let call: UIImageView = cell.viewWithTag(1) as! UIImageView
                call.accessibilityIdentifier = self.clientDetail?.myCareNetwork?[index].contactNumber
                call.isUserInteractionEnabled = true
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
                call.addGestureRecognizer(tap)
                self.myCareTableView.layoutSubviews()
                return cell
            } else {
                let array = [[
                    MyPopupListModel(title:"Name",value: self.clientDetail?.myCareNetwork?[indexPath.row - 1].name ?? ""),
                    MyPopupListModel(title:"Age",value: (self.clientDetail?.myCareNetwork?[indexPath.row - 1].age?.value as? Int ?? 0).description),
                    MyPopupListModel(title:"Contact Number",value: self.clientDetail?.myCareNetwork?[indexPath.row - 1].contactNumber ?? ""),
                    MyPopupListModel(title:"Email",value: self.clientDetail?.myCareNetwork?[indexPath.row - 1].email ?? ""),
                    MyPopupListModel(title:"Address",value: self.clientDetail?.myCareNetwork?[indexPath.row - 1].address ?? ""),
                    MyPopupListModel(title:"City",value: self.clientDetail?.myCareNetwork?[indexPath.row - 1].city ?? ""),
                    MyPopupListModel(title:"Post Code",value: self.clientDetail?.myCareNetwork?[indexPath.row - 1].postCode ?? "")]]
                let cell = tableView.dequeueReusableCell(withClassIdentifier: InfoAboutStackTableViewCell.self,for: indexPath)
                cell.setupData(model: array.first!)
                cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.width, bottom: 0, right: 0)
                return cell
            }

        }else{
            let cell = tableView.dequeueReusableCell(withClassIdentifier: InfoAboutStackTableViewCell.self,for: indexPath)
            if ["ActivityRiskAssessment","BehaviourRiskAssessment","SelfAdministrationRiskAssessment","MedicationRiskAssessment","EquipmentRegister","FinancialRiskAssessment","COSHHRiskAssessment"].contains(self.list[indexPath.row].key){
                
                cell.setupData(riskModel: self.list[indexPath.row].risk, title: self.list[indexPath.row].title)
                
            }else{
                cell.setupData(model: self.list[indexPath.row].value, border: true, title: self.list[indexPath.row].title)
            }
            cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.width, bottom: 0, right: 0)
            return cell
//            let cell = tableView.dequeueReusableCell(withClassIdentifier: MyCareItemTableViewCell.self,for: indexPath)
//            cell.lblName.text = self.list[indexPath.row].title
//            self.carePlanTableView.layoutSubviews()
//            return cell
        }
    }
    
    @objc func handleTap(gesture:UITapGestureRecognizer){
        let imageView = gesture.view
        if let url = URL(string: imageView?.accessibilityIdentifier ?? "") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                return
            }
        }
            self.view.makeToast("No number found")
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedType == .care && (indexPath.row == 0 || indexPath.row - 1 != expendedIndex) {
//            let vc = Storyboard.Clients.instantiateViewController(withViewClass: PopupAboutMeInfoViewController.self)
            if expendedIndex == -1 {
                expendedIndex = indexPath.row
            } else if expendedIndex == indexPath.row {
                expendedIndex = -1
            } else {
                expendedIndex = indexPath.row > expendedIndex ? indexPath.row - 1 : indexPath.row
            }
            tableView.reloadData()
//            vc.titleStr = "About My Care Network \(self.clientDetail?.myCareNetwork?[indexPath.row].occupationType ?? "")"
//            vc.list = [[
//                MyPopupListModel(title:"Name",value: self.clientDetail?.myCareNetwork?[indexPath.row].name ?? ""),
//                MyPopupListModel(title:"Age",value: (self.clientDetail?.myCareNetwork?[indexPath.row].age?.value as? Int ?? 0).description),
//                MyPopupListModel(title:"Contact Number",value: self.clientDetail?.myCareNetwork?[indexPath.row].contactNumber ?? ""),
//                MyPopupListModel(title:"Email",value: self.clientDetail?.myCareNetwork?[indexPath.row].email ?? ""),
//                MyPopupListModel(title:"Address",value: self.clientDetail?.myCareNetwork?[indexPath.row].address ?? ""),
//                MyPopupListModel(title:"City",value: self.clientDetail?.myCareNetwork?[indexPath.row].city ?? ""),
//                MyPopupListModel(title:"Post Code",value: self.clientDetail?.myCareNetwork?[indexPath.row].postCode ?? "")]]
//            vc.transitioningDelegate = customTransitioningDelegate
//            vc.modalPresentationStyle = .custom
//            self.present(vc, animated: true)
        }else{
            if list.count <= indexPath.row{
                return
            }
            return
//            if ["ActivityRiskAssessment","BehaviourRiskAssessment","SelfAdministrationRiskAssessment","MedicationRiskAssessment","EquipmentRegister","FinancialRiskAssessment","COSHHRiskAssessment"].contains(self.list[indexPath.row].key){
//                let vc = Storyboard.Clients.instantiateViewController(withViewClass: PopupRiskAssListInfoViewController.self)
//                vc.list = self.list[indexPath.row].risk
//                vc.titleStr = self.list[indexPath.row].title
//                vc.transitioningDelegate = customTransitioningDelegate
//                vc.modalPresentationStyle = .custom
//                self.present(vc, animated: true)
//            } else {
//                return
//                let vc = Storyboard.Clients.instantiateViewController(withViewClass: PopupDisplayListInfoViewController.self)
//                vc.list = self.list[indexPath.row].value
//                vc.titleStr = self.list[indexPath.row].title
//                vc.transitioningDelegate = customTransitioningDelegate
//                vc.modalPresentationStyle = .custom
//                self.present(vc, animated: true)
//            }
        }
        
    }
}

class MyCareItemTableViewCell:UITableViewCell{
    @IBOutlet weak var bgView: AGView!
    @IBOutlet weak var lblName: UILabel!
}
// MARK: API Call
extension ClientDetailViewController {
    
    private func getClientDetail_APICall() {
        CustomLoader.shared.showLoader(on: self.view)
        WebServiceManager.sharedInstance.callAPI(apiPath: .getClientDetails(clientId: (self.client?.id ?? "").description), method: .get, params: [:],isAuthenticate: true, model: CommonRespons<ClientDetailModel>.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        self?.clientDetail = data.data
                        self?.setData()
//                        self.myCareTableView.reloadData()
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
    private func getRiskDetail_APICall() {
        
        CustomLoader.shared.showLoader(on: self.view)
        let client_id = (self.client?.id ?? "").description
        
        WebServiceManager.sharedInstance.callAPI(apiPath: .getClientCarePlanRisk,queryParams: ["client_id":client_id], method: .get, params: [:],isAuthenticate: true, model: CommonRespons<[[String: CodableValue]]>.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        if let d = data.data?.first{
                            self?.createCustomList(model: d)
                        }
                        self?.carePlanTableView.reloadData()
                    }else{
                        self?.view.makeToast(data.message ?? "")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {[weak self] in
//                    self?.view.makeToast(error.localizedDescription)
                }
            }
        }
    }
    private func getPlanCare_APICall() {
        
        CustomLoader.shared.showLoader(on: self.view)
        let client_id = (self.client?.id ?? "").description
        
        WebServiceManager.sharedInstance.callAPI(apiPath: .getClientCarePlanAss(clientId: client_id), method: .get, params: [:],isAuthenticate: true, model: CommonRespons<[[String: CodableValue]]>.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        if let d = data.data?.first{
                            for (key,value) in d{
                                if let value:[String:Any] = value.value as? [String:Any],!value.keys.isEmpty{
                                    var temp:MyCustomListModel = MyCustomListModel()
                                    temp.title = key.addSpaceBeforeUppercase()
                                    temp.key = key
                                    
                                    let questionKeys = value.keys.filter { $0.hasPrefix("questions_name_") }
                                    var l:[MyPopupListModel] = []
                                    for key in questionKeys {
                                        if let question = (value[key] as? CodableValue)?.value as? String {
                                            let index = key.replacingOccurrences(of: "questions_name_", with: "")
                                            let statusKey = "status_\(index)"
                                            let commentKey = "comment_\(index)"
                                            let comment = (value[commentKey] as? CodableValue)?.value as? String ?? "N/A"
                                            let status = (value[statusKey] as? CodableValue)?.value as? String ?? comment
                                            let q = question.replacingOccurrences(of: "<name>", with: self?.client?.fullName ?? "")//.replacingOccurrences(of: "<agency name>", with: UserDetails.shared.loginModel?.admin ?? "")
                                            l.append(MyPopupListModel(title: q,value: status))
                                        }
                                    }
                                    temp.value = l
                                    self?.list.append(temp)
                                }
                            }
                            self?.list = self?.list.sorted{$0.title < $1.title} ?? []
                        }
                        self?.carePlanTableView.reloadData()
                        self?.carePlanTableView.layoutSubviews()
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
    func createCustomList(model:[String: CodableValue]){
        for (key,value) in model{
            if let list =  value.value as? [CodableValue],!list.isEmpty{
                var l:[RiskAssesstment] = []
                var temp:MyCustomListModel = MyCustomListModel()
                temp.title = key.addSpaceBeforeUppercase()
                temp.key = key
                
                var m1:RiskAssesstment = RiskAssesstment()
                var last:RiskAssesstment = RiskAssesstment()
                last.isBottom = true
                var index:Int = 1
                for tt in list{
                    debugPrint(tt.value)
                    let t = (tt.value as? [String:CodableValue])?.toAnyObject() ?? [:]
                    if key == "ActivityRiskAssessment"{
                        var m:RiskAssesstment = RiskAssesstment()
                        m.value = [
                            MyPopupListModel(title: "Activity",value: t["activity"] as? String ?? ""),
                            MyPopupListModel(title: "Task/Support Required",value: t["task_support_required"] as? String ?? ""),
                            MyPopupListModel(title: "Risk",value: t["risk_level"] as? String ?? ""),
                            MyPopupListModel(title: "Risk Range",value: t["range"] as? String ?? ""),
                            MyPopupListModel(title: "Equipment",value: t["equipment"] as? String ?? ""),
                            MyPopupListModel(title: "Action to be taken",value: t["action_to_be_taken"] as? String ?? ""),
                        ]
                        l.append(m)
                    }else if key == "BehaviourRiskAssessment"{
                        
                        let potential_hazards = t["potential_hazards"] as? [CodableValue] ?? []
                        let regulatory_measures = t["regulatory_measures"] as? [CodableValue] ?? []
                        let risk_range = t["risk_range"] as? [CodableValue] ?? []
                        let support_methods = t["support_methods"] as? [CodableValue] ?? []
                        let controls_adequate = t["controls_adequate"] as? [CodableValue] ?? []
                        let level_of_risk = t["level_of_risk"] as? [CodableValue] ?? []
                        
                        m1.value = [MyPopupListModel(title: "Frequency Potential",value: t["frequency_potential"] as? String ?? ""),
                                    MyPopupListModel(title: "Affected By Behaviour",value: t["affected_by_behaviour"] as? String ?? ""),
                                    MyPopupListModel(title: "Potential Triggers",value: t["potential_triggers"] as? String ?? "")]
                        
                        for i in 0..<potential_hazards.count{
                            if (potential_hazards[i].value as? String ?? "") != ""{
                                var m:RiskAssesstment = RiskAssesstment()
                                
                                var array = [
                                    MyPopupListModel(title: potential_hazards[i].value as? String ?? "",value: ""),
                                    MyPopupListModel(title: "Level Of Risk",value: level_of_risk[i].value as? String ?? ""),
                                    MyPopupListModel(title: "Risk Range",value: risk_range[i].value as? String ?? ""),
                                    MyPopupListModel(title: "Support Methods",value: support_methods[i].value as? String ?? ""),
                                    MyPopupListModel(title: "Controls Adequate",value: controls_adequate[i].value as? String ?? ""),
                                ]
                                if regulatory_measures.count > 0 {
                                    array.append(MyPopupListModel(title: "Regulatory Measures",value: regulatory_measures[i].value as? String ?? ""))

                                }
                                m.value = array
                                m.isListItem = true
                                l.append(m)
                            }
                        }
                    }else if key == "SelfAdministrationRiskAssessment"{
                        m1.value = [
                            MyPopupListModel(title: "How to take the medicines?",value: t["take_medicines"] as? String ?? ""),
                            MyPopupListModel(title: "About any special instructions?",value: t["special_instructions"] as? String ?? ""),
                            MyPopupListModel(title: "About common, possible side effects?",value: t["side_effects"] as? String ?? ""),
                            MyPopupListModel(title: "What to do if they miss a dose?",value: t["missed_dose"] as? String ?? ""),
                            MyPopupListModel(title: "Any difficulty in reading the label on the medicines?",value: t["difficulty_reading_label"] as? String ?? ""),
                            MyPopupListModel(title: "Open their medication (blister packs, bottles)?",value: t[""] as? String ?? ""),
                            MyPopupListModel(title: "About safe storage?",value: t["safe_storage"] as? String ?? ""),
                            MyPopupListModel(title: "Agree to notify?",value: t["agrees_to_notify"] as? String ?? ""),
                            MyPopupListModel(title: "Responsible for reorder?",value: t["responsible_for_reorder"] as? String ?? ""),
                        ]
                        var m:RiskAssesstment = RiskAssesstment()
                        m.value = [
                            MyPopupListModel(title: "Medication \(index)",value:""),
                            MyPopupListModel(title: "Medicine Name",value: t["medicine_name"] as? String ?? ""),
                            MyPopupListModel(title: "Dose",value: t["dose"] as? String ?? ""),
                            MyPopupListModel(title: "Route",value: t["route"] as? String ?? ""),
                            MyPopupListModel(title: "Time/Frequency",value: t["time_frequency"] as? String ?? ""),
                            MyPopupListModel(title: "Self-Administration",value: t["self_administration"] as? String ?? ""),
                            MyPopupListModel(title: "Self-administer fully or partially?",value: t["self_administer_fully"] as? String ?? "")
                        ]
                        index += 1
                        m.isListItem = true
                        l.append(m)
                    }else if key == "MedicationRiskAssessment"{
                        var m:RiskAssesstment = RiskAssesstment()
                        m.value = [
                            MyPopupListModel(title: "Ordering",value: t["ordering"] as? String ?? ""),
                            MyPopupListModel(title: "Ordering Comments",value: t["ordering_comments"] as? String ?? ""),
                            MyPopupListModel(title: "Collecting",value: t["collecting"] as? String ?? ""),
                            MyPopupListModel(title: "Collecting Comments",value: t["collecting_comments"] as? String ?? ""),
                            MyPopupListModel(title: "Verbal Prompt",value: t["verbal_prompt"] as? String ?? ""),
                            MyPopupListModel(title: "Verbal Prompt Comments",value: t["verbal_prompt_comments"] as? String ?? ""),
                            MyPopupListModel(title: "Assisting",value: t["assisting"] as? String ?? ""),
                            MyPopupListModel(title: "Assisting Comments",value: t["assisting_comments"] as? String ?? ""),
                            MyPopupListModel(title: "Administering",value: t["administering"] as? String ?? ""),
                            MyPopupListModel(title: "Administering Comments",value: t["administering_comments"] as? String ?? ""),
                            MyPopupListModel(title: "Specialized Support",value: t["specialized_support"] as? String ?? ""),
                            MyPopupListModel(title: "Specialized Support Comments",value: t["specialized_support_comments"] as? String ?? ""),
                            MyPopupListModel(title: "Time Specific",value: t["time_specific"] as? String ?? ""),
                            MyPopupListModel(title: "Time Specific Comments",value: t["time_specific_comments"] as? String ?? ""),
                            MyPopupListModel(title: "Controlled Drugs",value: t["controlled_drugs"] as? String ?? ""),
                            MyPopupListModel(title: "Controlled Drugs Details",value: t["controlled_drugs_details"] as? String ?? ""),
                            MyPopupListModel(title: "Agency Notification",value: t["agency_notification"] as? String ?? ""),
                            MyPopupListModel(title: "Medication Collection Details",value: t["medication_collection_details"] as? String ?? ""),
                            MyPopupListModel(title: "PRN Medication",value: t["prn_medication"] as? String ?? ""),
                            MyPopupListModel(title: "Safe Storage",value: t["safe_storage"] as? String ?? ""),
                            MyPopupListModel(title: "Storage Location",value: t["storage_location"] as? String ?? ""),
                        ]
                        l.append(m)
                    }else if key == "EquipmentRegister"{
                        var m:RiskAssesstment = RiskAssesstment()
                        m.value = [
                            MyPopupListModel(title: "Equipment",value: t["equipment"] as? String ?? ""),
                            MyPopupListModel(title: "Equipment Description",value: t["equipment_description"] as? String ?? ""),
                            MyPopupListModel(title: "Provided by",value: t["provided_by"] as? String ?? ""),
                            MyPopupListModel(title: "Purpose",value: t["purpose"] as? String ?? ""),
                            MyPopupListModel(title: "Date of next test",value: t["date_of_next_test"] as? String ?? ""),
                            MyPopupListModel(title: "Test completed on",value: t["test_completed_on"] as? String ?? ""),
                        ]
                        l.append(m)
                    }else if key == "FinancialRiskAssessment"{
                        var m:RiskAssesstment = RiskAssesstment()
                        m.value = [
                            MyPopupListModel(title: "Requires Assistance",value: t["requires_assistance"] as? String ?? ""),
                            MyPopupListModel(title: "Responsible Party",value: t["responsible_party"] as? String ?? ""),
                            MyPopupListModel(title: "Family Member Name",value: t["family_member_name"] as? String ?? ""),
                            MyPopupListModel(title: "Agency Name",value: t["agency_name"] as? String ?? ""),
                            MyPopupListModel(title: "Local Authority Name",value: t["local_authority_name"] as? String ?? ""),
                            MyPopupListModel(title: "Spending Limit",value: t["spending_limit"] as? String ?? ""),
                            MyPopupListModel(title: "Spending Details",value: t["spending_details"] as? String ?? ""),
                            MyPopupListModel(title: "Money Spend By",value: t["money_spent_by"] as? String ?? ""),
                            MyPopupListModel(title: "Activities Finances",value: t["activities_finances"] as? String ?? ""),
                            MyPopupListModel(title: "Safe Location",value: t["safe_location"] as? String ?? ""),
                            MyPopupListModel(title: "Provide Details",value: t["provide_details"] as? String ?? ""),
                        ]
                        l.append(m)
                    }else if key == "COSHHRiskAssessment"{
                        var m:RiskAssesstment = RiskAssesstment()
                        m.value = [
                            MyPopupListModel(title: "Name Of Product",value: t["name_of_product"] as? String ?? ""),
                            MyPopupListModel(title: "Type Of Harm",value: t["type_of_harm"] as? String ?? ""),
                            MyPopupListModel(title: "Description Substance",value: t["description_substance"] as? String ?? ""),
                            MyPopupListModel(title: "Color",value: t["color"] as? String ?? ""),
                            MyPopupListModel(title: "Details Substance",value: t["details_substance"] as? String ?? ""),
                            MyPopupListModel(title: "Contact Substance",value: t["contact_substance"] as? String ?? ""),
                        ]
                        l.append(m)
                    }else{
                        var m:RiskAssesstment = RiskAssesstment()
                        m.value = [
                            MyPopupListModel(title: "Activity",value: t["activity"] as? String ?? ""),
                            MyPopupListModel(title: "Task/Support Required",value: t["task_support_required"] as? String ?? ""),
                            MyPopupListModel(title: "Risk",value: t["risk_level"] as? String ?? ""),
                            MyPopupListModel(title: "Risk Range",value: t["range"] as? String ?? ""),
                            MyPopupListModel(title: "Equipment",value: t["equipment"] as? String ?? ""),
                            MyPopupListModel(title: "Action to be taken",value: t["action_to_be_taken"] as? String ?? ""),
                        ]
                        l.append(m)
                    }
                    
                    var date:[String] = []
                    if let d = t["date_1"] as? String{
                        date.append(d)
                    }
                    if let d = t["date_2"] as? String{
                        date.append(d)
                    }
                    last.date = date.joined(separator: "\n")
                    var name:[String] = []
                    if let d = t["sign_1"] as? String{
                        name.append(d)
                    }
                    if let d = t["sign_2"] as? String{
                        name.append(d)
                    }
                    last.name = name.joined(separator: "\n")
                }
                if key == "SelfAdministrationRiskAssessment" || key == "BehaviourRiskAssessment"{
                    l.insert(m1, at: 0)
                }
                l.append(last)
                temp.risk = l
                self.list.append(temp)
            }
        }
        self.list = self.list.sorted{$0.title < $1.title}
        self.carePlanTableView.reloadData()
        self.carePlanTableView.layoutSubviews()
    }
    
    private func getdocuments() {
        CustomLoader.shared.showLoader(on: self.view)
        guard let hashToken = UserDetails.shared.loginModel?.hashToken else {
           return
        }
        let param = ["client_id": self.client?.id ?? "",
                     APIParameters.hashToken: hashToken]
        WebServiceManager.sharedInstance.callAPI(apiPath: .getUploadedDocuments,  queryParams: param, method: .get, params: [:],isAuthenticate: true, model: CommonRespons<[Documents]>.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        self?.docArray = data.data ?? []
//                        self.setData()
//                        self.myCareTableView.reloadData()
                    }else{
//                        self?.view.makeToast(data.message ?? "")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async { 
//                    self?.view.makeToast(error.localizedDescription)
                }
            }
        }
    }
}
