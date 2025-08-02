//
//  UnscheduleViewController.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 10/03/25.
//

import UIKit

class UnscheduleViewController: UIViewController {

    var visitTimer: Timer?

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnCheckout: AGButton!
   
    @IBOutlet weak var btnTodo: AGButton!
    @IBOutlet weak var btnMedication: AGButton!
    @IBOutlet weak var btnVisitNotes: AGButton!
    
    @IBOutlet weak var btnNotes: AGButton!
    @IBOutlet weak var btnNotes1: AGButton!
    @IBOutlet weak var viewVisitNoData: UIView!
    @IBOutlet weak var addNoteView: UIStackView!
    
    @IBOutlet weak var lblTypeSelected: UILabel!
    @IBOutlet weak var lblNoDataText: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewAddnote: UIView!
    
    @IBOutlet weak var statusView: AGView!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var speratorView: UIView!
    
    var visit:VisitsModel?
    var visitType:VisitType = .none
    var selectedType:VisitDetailType = .medication
    
    var list:[UnscheduleNotesModel] = []
    var mediList1: [VisitMedicationModel] = []
    var mediList: [VisitMedicationModel] = []

    @IBOutlet weak var addView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        addView.isHidden = selectedType == .medication

        self.viewVisitNoData.isHidden = true
        self.viewAddnote.isHidden = true
        self.tableView.pullToRefreshScroll = { pull in
            pull.endRefreshing()
            self.getDataList_APICall()
        }
      
        self.btnTodo.action = {
            self.selectedType = .todo
            self.addView.isHidden = false
            self.setData()
        }
        self.btnMedication.action = {
            self.selectedType = .medication
            self.addView.isHidden = true
            self.viewAddnote.isHidden = true
            self.setData()
        }
        self.btnVisitNotes.action = {
            self.selectedType = .visitnote
            self.viewAddnote.isHidden = false
            self.setData()
        }
        self.btnCheckout.action = {
            if self.visitType != .onging{
                self.view.makeToast("Changes are not allowed")
                return
            }
            if (self.visit?.actualStartTime?.first ?? "").isEmpty{
                let vc = Storyboard.Visits.instantiateViewController(withViewClass: CheckinCheckoutViewController.self)
                vc.visit =  self.visit
                vc.isCheckin = true
                AppDelegate.shared.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            }else{
                guard let startTimeStr = self.visit?.actualStartTime?.first, !startTimeStr.isEmpty else {return}
                guard let visitDateStr = self.visit?.visitDate, !visitDateStr.isEmpty else { return}

                let fullDateTimeStr = "\(visitDateStr) \(startTimeStr)"
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                dateFormatter.timeZone = .current// TimeZone(identifier: "Europe/London")

                if let startDate = dateFormatter.date(from: fullDateTimeStr) {
                    let currentDate = Date()
                    let calendar = Calendar.current
                    let components = calendar.dateComponents([.minute], from: startDate, to: currentDate)
//                    if currentDate < startDate {
//                        self.lblTime.text = "Time's up!"
//                        return
//                    }
                    if let minutes = components.minute,minutes < 2{
                        return
                    }
                }else{
                    return
                }
                
                let params = [:] as [String : Any]
                CustomLoader.shared.showLoader(on: self.view)
                WebServiceManager.sharedInstance.callAPI(apiPath: .gettodoessentialdetails(visitId: (self.visit?.visitDetailsID ?? "").description), method: .get, params: params,isAuthenticate: true, model: EmptyReponse.self) { response, successMsg in
                    CustomLoader.shared.hideLoader()
                    switch response {
                    case .success(let data):
                        DispatchQueue.main.async {[weak self] in
                            if data.statusCode == 200{
                                let vc = Storyboard.Visits.instantiateViewController(withViewClass: CheckinCheckoutViewController.self)
                                vc.visit =  self?.visit
                                vc.isCheckin = false
                                AppDelegate.shared.topViewController()?.navigationController?.pushViewController(vc, animated: true)
                            }else{
                                AppDelegate.shared.topViewController()?.view.makeToast("Please first complete all essential")
                            }
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            AppDelegate.shared.topViewController()?.view.makeToast(error.localizedDescription)
                        }
                    }
                }
            }
        }
         self.btnNotes.action = {
            self.addNote()
        }
        self.btnNotes1.action = {
            self.addNote()
        }
        updateVisitTime() // initial update
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.visitType == .onging{
            startVisitTimer()
        }
        self.setData()
        self.getVisitDetail_APICall()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        visitTimer?.invalidate()
        visitTimer = nil
    }
    
    func addNote(){
        if self.visitType != .onging{
            self.view.makeToast("Changes are not allowed")
            return
        }
        let vc = Storyboard.Visits.instantiateViewController(withViewClass: AddEditUnscheduleVisitNotesViewController.self)
        vc.visitDetaiID = (self.visit?.visitDetailsID ?? "").description
        vc.updateHandler = {
            self.getDataList_APICall()
        }
        vc.transitioningDelegate = customTransitioningDelegate
        vc.selectedType = selectedType
        vc.modalPresentationStyle = .custom
        self.present(vc, animated: true)
    }
    func setData(){
        
        self.lblName.text = self.visit?.clientName
        self.lblAddress.text = self.visit?.clientAddress
        if let clientPostcode = self.visit?.clientPostcode, let clientCity = self.visit?.clientCity {
            self.lblAddress.text = ( self.visit?.clientAddress ?? "") + "\n" + clientCity + ", " + clientPostcode
        }
       // self.lblTime.text = (self.visit?.totalActualTimeDiff?.first ?? "").isEmpty ? "00:00" : (self.visit?.totalActualTimeDiff?.first ?? "")
        
        self.setupUnselected(view: btnTodo)
        self.setupUnselected(view: btnMedication)
        self.setupUnselected(view: btnVisitNotes)
       
        if self.visitType == .completed{
            self.statusView.borderColor = UIColor(named: "appGreen") ?? .green
            self.statusView.backgroundColor = UIColor(named: "appGreen")?.withAlphaComponent(0.1) ?? .green
            self.timeView.backgroundColor = UIColor(named: "appGreen")?.withAlphaComponent(0.1) ?? .green
            self.btnCheckout.backgroundColor = UIColor(named: "appGreen")
            self.speratorView.backgroundColor = UIColor(named: "appGreen")
            self.btnCheckout.setTitle("Completed", for: .normal)
        }else if self.visitType == .notcompleted{
            self.statusView.borderColor = UIColor(named: "appRed") ?? .red
            self.statusView.backgroundColor = UIColor(named: "appRed")?.withAlphaComponent(0.1) ?? .red
            self.timeView.backgroundColor = UIColor(named: "appRed")?.withAlphaComponent(0.1) ?? .red
            self.btnCheckout.backgroundColor = UIColor(named: "appRed")
            self.speratorView.backgroundColor = UIColor(named: "appRed")
            self.btnCheckout.setTitle("Not Completed", for: .normal)
        }else if self.visitType == .onging{
            self.statusView.borderColor = UIColor(named: "appBlue") ?? .blue
            self.statusView.backgroundColor = UIColor(named: "appBlue")?.withAlphaComponent(0.1) ?? .blue
            self.timeView.backgroundColor = UIColor(named: "appBlue")?.withAlphaComponent(0.1) ?? .blue
            self.btnCheckout.backgroundColor = UIColor(named: "appBlue")
            self.speratorView.backgroundColor = UIColor(named: "appBlue")
            if (self.visit?.actualStartTime?.first ?? "").isEmpty{
                self.btnCheckout.setTitle("Checkin", for: .normal)
            }else{
                self.btnCheckout.setTitle("Checkout", for: .normal)
            }
        }
        
        if selectedType == .todo{
            self.setupSelected(view: btnTodo)
            self.lblTypeSelected.text = "List of To-Do Notes"
            self.lblNoDataText.text = "The To-Do note is currently empty, \n Please provide your To-do documentation."
        }else if selectedType == .medication{
            self.setupSelected(view: btnMedication)
            self.lblTypeSelected.text = "List of Medication Notes"
            self.lblNoDataText.text = "The Medication note is currently empty, \nPlease provide your Medication documentation."
        }else if selectedType == .visitnote{
            self.setupSelected(view: btnVisitNotes)
            self.lblTypeSelected.text = "List of Visit Notes"
            self.lblNoDataText.text = "The visit note is currently empty, \nPlease provide your visit documentation."
        }
        self.lblTypeSelected.isHidden = true
        self.getDataList_APICall()
    }
    func setupSelected(view:AGButton){
        view.backgroundColor = UIColor(named: "appGreen")
        view.setTitleColor(.white, for: .normal)
    }
    func setupUnselected(view:AGButton){
        view.backgroundColor = UIColor(named: "appBlue")?.withAlphaComponent(0.10) ?? .blue
        view.setTitleColor(UIColor(named: "appDarkText") ?? .gray, for: .normal)
    }
    
    private func startVisitTimer() {
        visitTimer?.invalidate()
        visitTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateVisitTime()
        }
        RunLoop.main.add(visitTimer!, forMode: .common)
        updateVisitTime() // initial update
    }

    private func updateVisitTime() {
        guard let startTimeStr = self.visit?.actualStartTime?.first, !startTimeStr.isEmpty else {
            self.lblTime.text = "00:00"
            return
        }

        guard let visitDateStr = self.visit?.visitDate, !visitDateStr.isEmpty else {
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
            let components = calendar.dateComponents([.hour, .minute, .second], from: startDate, to: currentDate)
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
            if hours > 0 {
                self.lblTime.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            } else {
                self.lblTime.text = String(format: "%02d:%02d", minutes, seconds)
            }
        } else {
            self.lblTime.text = "00:00"
        }
    }
}
extension UnscheduleViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return selectedType == .medication ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if selectedType == .medication && section == 1 {
            return 40
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        view.backgroundColor = .white
        if section == 1 {
//            var lbl = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
//            lbl.textColor = .black
//            lbl.text = "PRN Medication"
//            view.addSubview(lbl)
            
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedType == .medication {
            return section == 1 ? self.mediList1.count : self.mediList.count
        }
        return self.list.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if selectedType == .medication {
            let cell = tableView.dequeueReusableCell(withClassIdentifier: StatusUpdateTableCell.self,for: indexPath)
            let model = indexPath.section == 1 ? self.mediList1[indexPath.row] : self.mediList[indexPath.row]
            cell.lblName.text = model.nhsMedicineName
            cell.lblStatus.text = model.status
            if model.status == "Scheduled" {
                cell.lblStatus.numberOfLines = 2
                cell.lbltype.text = "\(model.status ?? "")\n\(model.timeFrame ?? "")"
            }
            if (model.status ?? "") == ""{
                cell.viewStatus.isHidden = true
            }else if (model.status ?? "") == "FullyTaken"{
                cell.viewStatus.isHidden = false
                cell.viewStatus.backgroundColor = UIColor(named: "appGreen") ?? .green
            }else if (model.status ?? "") == "Scheduled" || (model.status ?? "") == "Not Scheduled"{
                cell.viewStatus.isHidden = true
                cell.viewStatus.backgroundColor = UIColor(named: "appGray") ?? .gray
            }else if (model.status ?? "") != ""{
                cell.viewStatus.isHidden = false
                cell.viewStatus.backgroundColor = UIColor(named: "appRed") ?? .red
            }else{
                cell.viewStatus.isHidden = true
            }
            if model.medicationType == "PRN" {
                cell.lbltype.text =  "PRN \n\(model.doses ?? 0) Doses per \(model.dosePer ?? 0) \(model.timeFrame ?? "")"
            }

            self.tableView.layoutSubviews()
            return cell
        }
        
        if indexPath.row == list.count {
            let cell = tableView.dequeueReusableCell(withClassIdentifier: AddNotesTableViewCell.self,for: indexPath)
            cell.clickHandler = {
                self.addNote()
            }
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withClassIdentifier: UnscheduleVisitNotesTableCell.self,for: indexPath)
        cell.setupData(model: self.list[indexPath.row])
        cell.selectedType = self.selectedType
        cell.clickHandler = {
            if self.visitType != .onging{
                self.view.makeToast("Changes are not allowed")
                return
            }
            let vc = Storyboard.Visits.instantiateViewController(withViewClass: AddEditUnscheduleVisitNotesViewController.self)
            vc.visitDetaiID = (self.visit?.visitDetailsID ?? "").description
            vc.isEdit = true
            vc.visitNotes = self.list[indexPath.row]
            vc.updateHandler = {
                self.getDataList_APICall()
            }
            vc.transitioningDelegate = customTransitioningDelegate
            vc.modalPresentationStyle = .custom
            self.present(vc, animated: true)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.visitType != .onging {
            self.view.makeToast("Changes are not allowed")
            return
        }
        
        if selectedType == .medication {
            let vc = Storyboard.Visits.instantiateViewController(withViewClass: AddEditMedicationViewController.self)
            let model = indexPath.section == 1 ? self.mediList1[indexPath.row] : self.mediList[indexPath.row]

            vc.medication = model
            vc.visit = self.visit
//            if model.medicationType == "PRN" {
                vc.mediFlag = indexPath.section == 1
//            }

            vc.updateHandler = {
                self.getDataList_APICall()
            }
//            vc.transitioningDelegate = customTransitioningDelegate
            vc.modalPresentationStyle = .pageSheet
            self.present(vc, animated: true)
            return
        }
        
        let vc = Storyboard.Visits.instantiateViewController(withViewClass: AddEditVisitNotesViewController.self)
        vc.transitioningDelegate = customTransitioningDelegate
//        vc.selectedType = visitType
        vc.modalPresentationStyle = .custom
        self.present(vc, animated: true)
    }
}

// MARK: API Call
extension UnscheduleViewController {
    
    private func getDataList_APICall() {
        let id = (self.visit?.visitDetailsID ?? "")
       // id = 2855
        var api:APIType = .addAlert
        if selectedType == .todo{
            return
//            api = .getTodoDetails(todoId: id.description)
        }else if selectedType == .medication{
            getDataList_APICall1()
            return
            return
            api = .getMedicationDetailsById(medicationId: id.description)
        }else if selectedType == .visitnote{
            api = .getVisitNotes(visitNotesId: id.description)
        }
        CustomLoader.shared.showLoader(on: self.view)

        WebServiceManager.sharedInstance.callAPI(apiPath: api, method: .get, params: [:],isAuthenticate: false, model: CommonRespons<[UnscheduleNotesModel]>.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        
                        self?.list = data.data ?? []
//                        self?.viewVisitNoData.isHidden = !(self?.list.isEmpty ?? [])
//                       self.addNoteView.isHidden = self.list.isEmpty
                        
                        self?.viewVisitNoData.isHidden = !(self?.list.isEmpty ?? false)

                        self?.tableView.reloadData()
                    }else{
                        self?.list = []
//                        self.viewVisitNoData.isHidden = !self.list.isEmpty
//                        self.addNoteView.isHidden = self.list.isEmpty
                        //self?.tableView.reloadData()
                        self?.view.makeToast(data.message ?? "")
                    }
//                    if self?.selectedType == .medication{
//                        self?.getDataListPRN_APICall()
//                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {[weak self] in
                    self?.view.makeToast(error.localizedDescription)
                }
            }
        }
    }
    
    private func getDataList_APICall1() {
        let id = (self.visit?.visitDetailsID ?? "")
       // id = 2855
        var api:APIType = .addAlert
        if selectedType == .medication{
            api = .getMedicationDetailsById(medicationId: id.description)
        }else if selectedType == .visitnote{
            api = .getVisitNotes(visitNotesId: id.description)
        }
        CustomLoader.shared.showLoader(on: self.view)

        WebServiceManager.sharedInstance.callAPI(apiPath: api, method: .get, params: [:],isAuthenticate: false, model: CommonRespons<[VisitMedicationModel]>.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        
                        self?.mediList = data.data ?? []
//                        self.viewVisitNoData.isHidden = !self.list.isEmpty
//                        self.addNoteView.isHidden = self.list.isEmpty
//                        self?.tableView.reloadData()
                    }else{
                        self?.mediList = []
//                        self.viewVisitNoData.isHidden = !self.list.isEmpty
//                        self.addNoteView.isHidden = self.list.isEmpty
                        self?.viewVisitNoData.isHidden = !(self?.list.isEmpty ?? false)
                        
//                        self?.tableView.reloadData()
                        self?.view.makeToast(data.message ?? "")
                    }
                    if self?.selectedType == .medication{
                        self?.getDataListPRN_APICall()
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {[weak self] in
                    self?.view.makeToast(error.localizedDescription)
                }
            }
        }
    }

    
    private func getDataListPRN_APICall() {
//        mediList1 = []
//        if let data = self.loadMutaionJSONFromFile() {
//            self.mediList = data.data ?? [] //(self.list ?? []) + (data.data ?? [])
//            self.tableView.reloadData()
//            return;
//        }
//        return;

        CustomLoader.shared.showLoader(on: self.view)
        let params: [String: String] = ["client_id" : self.visit?.clientID ?? "",
                                     "date" : (self.visit?.visitDate ?? "")]

        WebServiceManager.sharedInstance.callAPI(apiPath: .getunscheduledMedicationPrn,
                                                 queryParams: params,
                                                 method: .get,
                                                 params: [:],
                                                 isAuthenticate: false,
                                                 model: CommonRespons<[VisitMedicationModel]>.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        self?.mediList1 = (data.data ?? [])

                        self?.tableView.reloadData()
                    }else{
                        self?.mediList1 = []
                        self?.tableView.reloadData()
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
    
    func loadMutaionJSONFromFile() -> CommonRespons<[VisitMedicationModel]>? {
        guard let url = Bundle.main.url(forResource: "mutation", withExtension: "json") else {
            print("JSON file not found")
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let countries = try decoder.decode(CommonRespons<[VisitMedicationModel]>.self, from: data)
            return countries
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }

    private func getVisitDetail_APICall() {
        WebServiceManager.sharedInstance.callAPI(apiPath: .getVisitDetails(visitId: (self.visit?.visitDetailsID ?? "").description,
                                                                           userId: UserDetails.shared.user_id),
                                                 method: .get,
                                                 params: [:],
                                                 isAuthenticate: true,
                                                 model: CommonRespons<[VisitsModel]>.self) { response, successMsg in
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        self?.visit = data.data?.first
                        self?.setData()
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

