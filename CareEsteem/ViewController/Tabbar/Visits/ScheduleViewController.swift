//
//  ScheduleViewController.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 09/03/25.
//

import UIKit

enum VisitDetailType{
    case todo
    case medication
    case visitnote
}
class ScheduleViewController: UIViewController, UITextFieldDelegate {
    var searchActive = false
    var visitTimer: Timer?

     var noNotesIV: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnCheckout: AGButton!
   
    @IBOutlet weak var viewTodo: UIView!
    @IBOutlet weak var viewMedication: UIView!
    @IBOutlet weak var viewVisitNotes: UIView!
    
    @IBOutlet weak var btnTodo: AGButton!
    @IBOutlet weak var btnMedication: AGButton!
    @IBOutlet weak var btnVisitNotes: AGButton!
    
    @IBOutlet weak var planTimeLbl: UILabel!
    @IBOutlet weak var todoTF: UITextField!
    @IBOutlet weak var btnAddVisitNotes: AGButton!
    @IBOutlet weak var viewVisitNotesNoData: UIView!
    
    @IBOutlet weak var statusView: AGView!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var speratorView: UIView!
    @IBOutlet weak var tf: UITextField!
    var imageView: UIImageView!
    
    var visit:VisitsModel?
    var selectedType:VisitDetailType = .todo
    var visitType:VisitType = .none
    @IBOutlet weak var todoTableView: AGTableView!
    @IBOutlet weak var medicationTableView: AGTableView!
    @IBOutlet weak var pnrMedicationTableView: AGTableView!
    @IBOutlet weak var visitNoteTableView: AGTableView!
    
    @IBOutlet weak var todoScroll: UIScrollView!
    @IBOutlet weak var medicationScroll: UIScrollView!
    @IBOutlet weak var visitNoteScroll: UIScrollView!
    
    @IBOutlet weak var lblTodoCount: UILabel!
    @IBOutlet weak var lblMedicationCount: UILabel!
    
    var todoList:[VisitTodoModel] = []
    var todoFilterList:[VisitTodoModel] = []
    var medicationList:[VisitMedicationModel] = []
    var medicationFilterList:[VisitMedicationModel] = []
    var pnrMedicationList:[VisitMedicationModel] = []
    var visitNotesList:[VisitNotesModel] = []
    
    @objc func singleTap(sender: UITapGestureRecognizer) {
//        self.tf.resignFirstResponder()
    }
    
    func textFieldoutLines(txtFld: UITextField) {
        txtFld.delegate = self
        txtFld.placeholder = "Search"
        txtFld.layer.borderWidth = 1
        txtFld.layer.borderColor = UIColor(named: "appGreen")?.cgColor
        txtFld.layer.cornerRadius = 5
        txtFld.clipsToBounds = true
        txtFld.leftViewMode = .always
        let imagView = UIImageView(frame: CGRect(x: 5, y: 5, width: 15, height: 15))
        let image = UIImage(named: "searchIcon")
        imagView.image = image
        let bg = UIView(frame: CGRect(x: 0, y: 5, width: 22, height: 22))
        bg.addSubview(imagView)
        txtFld.leftView = bg
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldoutLines(txtFld: tf)
        textFieldoutLines(txtFld: todoTF)
        planTimeLbl.text = "Planned Time : \(self.visit?.plannedStartTime ?? "") - \(self.visit?.plannedEndTime ?? "")"
        noNotesIV = self.view.viewWithTag(4) as? UIImageView
        let imageData = try! Data(contentsOf: Bundle.main.url(forResource: "44 Notes", withExtension: "gif")!)
        noNotesIV.image = UIImage.sd_image(withGIFData: imageData)
//        btnAddVisitNotes.isHidden = true
        imageView = UIImageView.init(frame: CGRect(x: 0, y: 255, width: 10, height: 5))
        imageView.image = UIImage(named: "polygon")
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.singleTap(sender:)))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(singleTapGestureRecognizer)
        
        self.todoScroll.pullToRefreshScroll = { pull in
            pull.endRefreshing()
            self.getTodoList_APICall()
        }
        self.medicationScroll.pullToRefreshScroll = { pull in
            pull.endRefreshing()
            self.getMedicationList_APICall()
        }
        self.visitNoteScroll.pullToRefreshScroll = { pull in
            pull.endRefreshing()
            self.getVisitNoteList_APICall()
        }
        
        self.btnTodo.action = {
            self.selectedType = .todo
            self.setData()
        }
        self.btnMedication.action = {
            self.selectedType = .medication
            self.setData()
        }
        self.btnVisitNotes.action = {
            self.selectedType = .visitnote
            self.setData()
        }
        self.viewVisitNotesNoData.isHidden = true
        self.btnCheckout.action = {
            
         
            if self.visitType != .onging{
                self.view.makeToast("Changes are not allowed")
                return
            }
            if (self.visit?.actualStartTime?.first ?? "").isEmpty {
                if convertDateToString(date: Date(), format: "yyyy-MM-dd",timeZone: TimeZone(identifier: "Europe/London")) == self.visit?.visitDate{
                    let vc = Storyboard.Visits.instantiateViewController(withViewClass: CheckinCheckoutViewController.self)
                    vc.visit =  self.visit
                    vc.isCheckin = true
                    AppDelegate.shared.topViewController()?.navigationController?.pushViewController(vc, animated: true)
                }
            }else{
                guard let startTimeStr = self.visit?.actualStartTime?.first, !startTimeStr.isEmpty else {return}
                guard let visitDateStr = self.visit?.visitDate, !visitDateStr.isEmpty else { return}

                let fullDateTimeStr = "\(visitDateStr) \(startTimeStr)"
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                dateFormatter.timeZone = .current//TimeZone(identifier: "Europe/London")

                if let startDate = dateFormatter.date(from: fullDateTimeStr) {
                    let currentDate = Date()
                    let calendar = Calendar.current
                    let components = calendar.dateComponents([.minute], from: startDate, to: currentDate)
//                    if currentDate < startDate {
//                        self.lblTime.text = "Time's up!"
//                        return
//                    }
                    if let minutes = components.minute, minutes < 2 && minutes > -1 {
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
                            if data.statusCode == 200 {
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
        self.btnAddVisitNotes.action = {
            if self.visitType != .onging{
                self.view.makeToast("Changes are not allowed")
                return
            }
            let vc = Storyboard.Visits.instantiateViewController(withViewClass: AddEditVisitNotesViewController.self)
            vc.visitDetaiID = (self.visit?.visitDetailsID ?? "").description
            self.viewVisitNotesNoData.isHidden = false
            self.visitNoteTableView.isHidden = true
            vc.updateHandler = {
                self.getVisitNoteList_APICall()
            }
//            vc.transitioningDelegate = customTransitioningDelegate
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
        updateVisitTime() // initial update
        self.view.addSubview(imageView)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.visitType == .onging{
            startVisitTimer()
        }
        btnTodo.roundCorners([.topLeft, .topRight], radius: 10)
        btnMedication.roundCorners([.topLeft, .topRight], radius: 10)
        btnVisitNotes.roundCorners([.topLeft, .topRight], radius: 10)
        

        self.setData()
        self.getVisitDetail_APICall()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        visitTimer?.invalidate()
        visitTimer = nil
    }
    
    func setData() {
        self.lblName.text = self.visit?.clientName
        self.lblAddress.text = self.visit?.clientAddress
        if let clientPostcode = self.visit?.clientPostcode, let clientCity = self.visit?.clientCity{
            self.lblAddress.text = ( self.visit?.clientAddress ?? "") + "\n" + clientCity + ", " + clientPostcode
        }
        // self.lblTime.text = (self.visit?.totalActualTimeDiff?.first ?? "").isEmpty ? "00:00" : (self.visit?.totalActualTimeDiff?.first ?? "")

        self.setupUnselected(view: btnTodo)
        self.setupUnselected(view: btnMedication)
        self.setupUnselected(view: btnVisitNotes)

        self.viewTodo.isHidden = true
        self.viewMedication.isHidden = true
        self.viewVisitNotes.isHidden = true
        self.viewVisitNotesNoData.isHidden = true

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
            updateImageViewFrame(btn: btnTodo)
            self.viewTodo.isHidden = false
            self.getTodoList_APICall()
        }else if selectedType == .medication{
            self.setupSelected(view: btnMedication)
            self.viewMedication.isHidden = false
            updateImageViewFrame(btn: btnMedication)
            self.getMedicationList_APICall()
        }else if selectedType == .visitnote{
            self.setupSelected(view: btnVisitNotes)
            self.viewVisitNotes.isHidden = false
            updateImageViewFrame(btn: btnVisitNotes)
            self.getVisitNoteList_APICall()
        }
    }

    func updateImageViewFrame(btn: AGButton) {
//        let view1 = self.view.viewWithTag(10)
        imageView.frame =  CGRect(x: (btn.frame.origin.x + btn.frame.width / 2 + 5), y: 267, width: 10, height: 5)
    }
    
    private func startVisitTimer() {
        visitTimer?.invalidate()
        visitTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateVisitTime()
        }
        
        RunLoop.main.add(visitTimer!, forMode: .common)
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
//            if hours > 0 {
//                self.lblTime.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
//            } else {
                self.lblTime.text = String(format: "%02d:%02d", minutes, seconds)
//            }
        } else {
            self.lblTime.text = "00:00"
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
extension ScheduleViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == todoTableView{
            return searchActive ? self.todoFilterList.count :self.todoList.count
        }else if tableView == medicationTableView{
            return searchActive ? self.medicationFilterList.count : self.medicationList.count
        }else if tableView == pnrMedicationTableView{
            return self.pnrMedicationList.count
        }else if tableView == visitNoteTableView{
            return self.visitNotesList.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == todoTableView {
            let cell = tableView.dequeueReusableCell(withClassIdentifier: ToDoStatusUpdateTableCell.self,
                                                     for: indexPath)
            let model = searchActive ? todoFilterList[indexPath.row] : todoList[indexPath.row]
            cell.lblName.text = model.todoName
//            cell.lblStatus.text = model.todoOutcome
            if model.todoEssential ?? false {
                cell.lblName.text = (model.todoName ?? "") + "*"
                let range = (cell.lblName.text! as NSString).range(of: "*")

                let mutableAttributedString = NSMutableAttributedString.init(string: cell.lblName.text!)
                mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                                     value: UIColor(named: "appGreen") ?? .green,
                                                     range: range)

                cell.lblName.attributedText = mutableAttributedString
            }
            if (model.todoOutcome ?? "") == "Not Completed"{
                cell.viewStatus.isHidden = false
                cell.viewStatus.image = UIImage(named: "rejectedIcon")
                cell.widthConstraint.constant = 20
                cell.leadingConstraint.constant = 14
            }else if (model.todoOutcome ?? "") == "Completed"{
                cell.viewStatus.isHidden = false
                cell.viewStatus.image = UIImage(named: "acceptedIcon")
                cell.widthConstraint.constant = 20
                cell.leadingConstraint.constant = 14

            } else {
                cell.viewStatus.isHidden = true
                cell.widthConstraint.constant = 0
                cell.leadingConstraint.constant = 0
            }

            self.todoTableView.layoutSubviews()
            return cell
        } else if tableView == medicationTableView {
            let cell = tableView.dequeueReusableCell(withClassIdentifier: StatusUpdateTableCell.self,for: indexPath)
            let array = searchActive ? self.medicationFilterList : self.medicationList
            let data = array[indexPath.row]
            cell.lblName.text = data.nhsMedicineName
            cell.lbldesc.text = data.medicationSupport
            cell.lbltype.text = data.medicationType
            cell.lblStatus.text = data.status
            if (data.medicationType == "Scheduled") {
                if(data.selectPreference?.lowercased() == "by exact time") {
                    cell.lbltype.text = cell.lbltype.text! +  "\n\(data.by_exact_time ?? "")"
                } else if(data.selectPreference?.lowercased() == "by session") {
                    cell.lbltype.text = cell.lbltype.text! +  "\n@\(data.session_type ?? "")"
                } else {
                    cell.lbltype.text = cell.lbltype.text! +  "\n@ N/A"
                }
            }
            if (data.medicationType == "PRN") {
                cell.lbltype.text = cell.lbltype.text! +  "\n\(data.doses ?? 0) Doses per \(data.dosePer ?? 0) \(data.timeFrame ?? "")"
            }
            if (array[indexPath.row].status ?? "") == ""{
                cell.viewStatus.isHidden = true
            } else if (array[indexPath.row].status ?? "") == "FullyTaken"{
                cell.viewStatus.isHidden = false
                cell.viewStatus.backgroundColor = UIColor(named: "appGreen") ?? .green
            } else if (array[indexPath.row].status ?? "") == "Scheduled" || (array[indexPath.row].status ?? "") == "Not Scheduled"{
                cell.viewStatus.isHidden = true
                cell.viewStatus.backgroundColor = UIColor(named: "appGray") ?? .gray
            } else if (array[indexPath.row].status ?? "") != "" {
                cell.viewStatus.isHidden = false
                cell.viewStatus.backgroundColor = UIColor(named: "appRed") ?? .red
            } else {
                cell.viewStatus.isHidden = true
            }
            self.medicationTableView.layoutSubviews()
            return cell
        }else if tableView == pnrMedicationTableView {
            let cell = tableView.dequeueReusableCell(withClassIdentifier: StatusUpdateTableCell.self,for: indexPath)
            cell.lblName.text = self.pnrMedicationList[indexPath.row].nhsMedicineName
            cell.lblStatus.text = self.pnrMedicationList[indexPath.row].status
            if self.pnrMedicationList[indexPath.row].status == "Scheduled" {
                cell.lblStatus.numberOfLines = 2
                cell.lblStatus.text = "\(self.pnrMedicationList[indexPath.row].status)\n\(self.pnrMedicationList[indexPath.row].timeFrame)"
            }
            if (self.pnrMedicationList[indexPath.row].status ?? "") == ""{
                cell.viewStatus.isHidden = true
            }else if (self.pnrMedicationList[indexPath.row].status ?? "") == "FullyTaken"{
                cell.viewStatus.isHidden = false
                cell.viewStatus.backgroundColor = UIColor(named: "appGreen") ?? .green
            }else if (self.pnrMedicationList[indexPath.row].status ?? "") == "Scheduled" || (self.pnrMedicationList[indexPath.row].status ?? "") == "Not Scheduled"{
                cell.viewStatus.isHidden = true
                cell.viewStatus.backgroundColor = UIColor(named: "appGray") ?? .gray
            }else if (self.pnrMedicationList[indexPath.row].status ?? "") != ""{
                cell.viewStatus.isHidden = false
                cell.viewStatus.backgroundColor = UIColor(named: "appRed") ?? .red
            }else{
                cell.viewStatus.isHidden = true
            }
//            if model.medicationType == "PRN" {
                cell.lbltype.text =  "PRN \n\(self.pnrMedicationList[indexPath.row].doses ?? 0) Doses per \(self.pnrMedicationList[indexPath.row].dosePer ?? 0) \(self.pnrMedicationList[indexPath.row].timeFrame ?? "")"
            cell.lbltype.numberOfLines = 3
            
//            }
            self.pnrMedicationTableView.layoutSubviews()
            return cell
        }else if tableView == visitNoteTableView{
            let cell = tableView.dequeueReusableCell(withClassIdentifier: VisitNotesTableCell.self,for: indexPath)
            cell.setupData(model: self.visitNotesList[indexPath.row])
            cell.clickHandler = {
                let vc = Storyboard.Visits.instantiateViewController(withViewClass: AddEditVisitNotesViewController.self)
                vc.visitDetaiID = (self.visit?.visitDetailsID ?? "").description
                vc.isEdit = true
                vc.visitNotes = self.visitNotesList[indexPath.row]
                vc.updateHandler = {
                    self.getVisitNoteList_APICall()
                }
                vc.transitioningDelegate = customTransitioningDelegate
                vc.modalPresentationStyle = .custom
                self.present(vc, animated: true)
            }
            self.visitNoteTableView.layoutSubviews()
            return cell
        }else{
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.visitType != .onging {
            self.view.makeToast("Changes are not allowed")
            return
        }
        if tableView == todoTableView{
            let vc = Storyboard.Visits.instantiateViewController(withViewClass: UpdateStatusViewController.self)
            vc.todo = self.todoList[indexPath.row]
            vc.updateHandler = {
                self.getTodoList_APICall()
            }
//            vc.transitioningDelegate = customTransitioningDelegate
            vc.modalPresentationStyle = .pageSheet
//            vc.modalPresentationStyle = .custom
            self.present(vc, animated: true)
        }else if tableView == medicationTableView{
//            
//            if self.medicationList[indexPath.row].medicationType == "PRN"{
//
//                return
//            }
            
            let vc = Storyboard.Visits.instantiateViewController(withViewClass: AddEditMedicationViewController.self)
            vc.medication = self.medicationList[indexPath.row]
            vc.visit = self.visit
            if self.medicationList[indexPath.row].medicationType == "PRN" {
                vc.mediFlag = true
            }

            vc.updateHandler = {
                self.getMedicationList_APICall()
            }
//            vc.transitioningDelegate = customTransitioningDelegate
            vc.modalPresentationStyle = .pageSheet
            self.present(vc, animated: true)
        }else if tableView == pnrMedicationTableView{
            let vc = Storyboard.Visits.instantiateViewController(withViewClass: AddEditMedicationViewController.self)
            vc.medication = self.pnrMedicationList[indexPath.row]
            vc.visit = self.visit
            vc.updateHandler = {
                self.getMedicationList_APICall()
            }
            vc.transitioningDelegate = customTransitioningDelegate
            vc.modalPresentationStyle = .custom
            self.present(vc, animated: true)
        }else if tableView == visitNoteTableView{
          
        }
    }
}

// MARK: API Call
extension ScheduleViewController {
    
    private func getTodoList_APICall() {
        
        searchActive = false
        tf.text = ""
        todoTF.text = ""
        tf.resignFirstResponder()
        CustomLoader.shared.showLoader(on: self.view)
        let todoId = (self.visit?.visitDetailsID ?? "").description
      //  todoId = "2908"
        WebServiceManager.sharedInstance.callAPI(apiPath: .getVisitTodoDetails(todoId: todoId), method: .get, params: [:],isAuthenticate: false, model: CommonRespons<[VisitTodoModel]>.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        self?.todoList = data.data ?? []
                        self?.todoTableView.reloadData()
                        let count = self?.todoList.filter { v in
                            (v.todoOutcome ?? "") != ""
                        }
                        self?.lblTodoCount.text = "Essentials : \(count?.count ?? 0)/\(self?.todoList.count ?? 0)"
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
    

    
    private func getMedicationList_APICall() {
        CustomLoader.shared.showLoader(on: self.view)
        var medicationId = (self.visit?.visitDetailsID ?? "").description
      //  medicationId = "2575"
        WebServiceManager.sharedInstance.callAPI(apiPath: .getMedicationDetailsById(medicationId: medicationId), method: .get, params: [:],isAuthenticate: false, model: CommonRespons<[VisitMedicationModel]>.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async { [weak self] in
                    if data.statusCode == 200{
                        self?.medicationList = []
                        self?.pnrMedicationList = []

                        let visitDetailsId = (self?.visit?.visitDetailsID ?? "").description

                        for t in data.data ?? [] {
                            let medicationType = t.medicationType ?? ""
                            let visitID = (t.visitDetailsID?.value as? String) ?? ""
                            
                            if medicationType.caseInsensitiveCompare("Blister Pack") == .orderedSame ||
                                medicationType.caseInsensitiveCompare("Scheduled") == .orderedSame ||
                                (medicationType.caseInsensitiveCompare("PRN") == .orderedSame && visitID == visitDetailsId) {
                                
                                self?.medicationList.append(t)
                            } else if medicationType.caseInsensitiveCompare("PRN") == .orderedSame && visitID != visitDetailsId {
                                self?.pnrMedicationList.append(t)
                            }
                        }

                        // Hide PRN section if empty
                        self?.view.viewWithTag(77)?.isHidden = self?.pnrMedicationList.isEmpty ?? true

                        // Calculate completed medication count (excluding Scheduled and Not Scheduled)
                        let completeCount = (data.data ?? []).filter {
                            let status = $0.status ?? ""
                            return status.caseInsensitiveCompare("Scheduled") != .orderedSame &&
                                   status.caseInsensitiveCompare("Not Scheduled") != .orderedSame
                        }

                        self?.lblMedicationCount.text = "Submitted : \(completeCount.count)/\(data.data?.count ?? 0)"

                        // Reload tables
                        self?.medicationTableView.reloadData()
                        self?.pnrMedicationTableView.reloadData()
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
    private func getVisitNoteList_APICall() {
        CustomLoader.shared.showLoader(on: self.view)
        WebServiceManager.sharedInstance.callAPI(apiPath: .getVisitNotesDetails(visitId: (self.visit?.visitDetailsID ?? "").description), method: .get, params: [:],isAuthenticate: true, model: CommonRespons<[VisitNotesModel]>.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        self?.visitNotesList = data.data ?? []
                        self?.viewVisitNotesNoData.isHidden = true
                        self?.visitNoteTableView.isHidden = false
                        self?.visitNoteTableView.reloadData()
                    }else{
                        self?.viewVisitNotesNoData.isHidden = false
                        self?.visitNoteTableView.isHidden = true
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
    private func getVisitDetail_APICall() {
        WebServiceManager.sharedInstance.callAPI(apiPath: .getVisitDetails(visitId: (self.visit?.visitDetailsID ?? "").description,userId: UserDetails.shared.user_id), method: .get, params: [:],isAuthenticate: true, model: CommonRespons<[VisitsModel]>.self) { response, successMsg in
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

extension ScheduleViewController {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        medicationFilterList = medicationList.filter { $0.nhsMedicineName?.lowercased().contains(searchText.lowercased()) ?? false
        }
        print(medicationFilterList.count)
        self.medicationTableView.reloadData()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var search = textField.text ?? ""
        if let r = Range(range, in: search){
            search.removeSubrange(r) // it will delete any deleted string.
        }
        search.insert(contentsOf: string, at: search.index(search.startIndex, offsetBy: range.location)) // it will insert any text.
        print(search)
        if textField == tf {
            searching(str: search)
        } else {
            searchingToDo(str: search)
        }
        return true
    }

//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        searching(str: textField.text ?? "")
//
//        return true
//    }
    
    func searchingToDo(str: String) {
        searchActive = true
        todoFilterList = todoList.filter { $0.todoName?.lowercased().contains(str.lowercased()) ?? false
        }
        if str.count == 0 {
            todoFilterList = todoList
        }
        print(medicationFilterList.count)
        self.todoTableView.reloadData()
    }
    
    func searching(str: String) {
        searchActive = true
        medicationFilterList = medicationList.filter { $0.nhsMedicineName?.lowercased().contains(str.lowercased()) ?? false
        }
        if str.count == 0 {
            medicationFilterList = medicationList
        }
        print(medicationFilterList.count)
        self.medicationTableView.reloadData()

    }
}
