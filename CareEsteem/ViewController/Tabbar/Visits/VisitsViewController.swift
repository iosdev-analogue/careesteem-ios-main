//
//  VisitsViewController.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 07/03/25.
//
import UIKit

var notificationCount:Int = 0

enum VisitType {
    case completed
    case notcompleted
    case onging
    case upcoming
    case none
}
struct VisitsSectionModel {
    var title:String = ""
    var type:VisitType = .none
    var isExpand:Bool = false
    var data:[VisitsModel] = []
}
class VisitsViewController: UIViewController {
    
    @IBOutlet weak var tableView: AGTableView!
    @IBOutlet weak var scroll: UIScrollView!
    
    @IBOutlet weak var btnPrev: AGButton!
    @IBOutlet weak var btnNext: AGButton!
    
    @IBOutlet weak var viewDate1: AGView!
    @IBOutlet weak var viewDate2: AGView!
    @IBOutlet weak var viewDate3: AGView!
    @IBOutlet weak var viewDate4: AGView!
    @IBOutlet weak var viewDate5: AGView!
    @IBOutlet weak var viewDate6: AGView!
    @IBOutlet weak var viewDate7: AGView!
    
    @IBOutlet weak var lblDate1: UILabel!
    @IBOutlet weak var lblDate2: UILabel!
    @IBOutlet weak var lblDate3: UILabel!
    @IBOutlet weak var lblDate4: UILabel!
    @IBOutlet weak var lblDate5: UILabel!
    @IBOutlet weak var lblDate6: UILabel!
    @IBOutlet weak var lblDate7: UILabel!
    
    @IBOutlet weak var btnDate1: AGButton!
    @IBOutlet weak var btnDate2: AGButton!
    @IBOutlet weak var btnDate3: AGButton!
    @IBOutlet weak var btnDate4: AGButton!
    @IBOutlet weak var btnDate5: AGButton!
    @IBOutlet weak var btnDate6: AGButton!
    @IBOutlet weak var btnDate7: AGButton!
    
    var imageView: UIImageView?
    var leftCount = 0
    var rightCount = 0
    
    @IBOutlet weak var lblMonth: UILabel!
    
    var list:[VisitsSectionModel] = []//[VisitsSectionModel(title:"Not Completed Visits",type:.notcompleted),VisitsSectionModel(title:"Completed Visits",type:.completed),VisitsSectionModel(title:"Ongoing Visits",type:.onging),VisitsSectionModel(title:"Upcoming Visits",type:.upcoming)]
    var selectedDate:Date = Date()
    var date:Date = Date()
    var startOfWeek:Date = Date()
    private let viewModel = VisitsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNotoficationList_APICall()
        let stackview: UIStackView = (self.view.viewWithTag(3) as? UIStackView)!
        let spacing = (self.view.frame.width - 40 - 36 * 7) / 6
        stackview.spacing = spacing
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.scroll.pullToRefreshScroll = { pull in
            self.getVisiteList_APICall()
        }
        
        self.btnPrev.action = {
            if self.leftCount == 3 {
                return
            }
            self.leftCount += 1
            self.rightCount -= 1
            var dateComponent = DateComponents()
            dateComponent.day = -7
            self.date = Calendar.current.date(byAdding: dateComponent, to: self.date) ?? Date()
            self.setupData()
        }
        
        self.btnNext.action = {
            if self.rightCount == 3 {
                return
            }
            self.rightCount += 1
            self.leftCount -= 1
            var dateComponent = DateComponents()
            dateComponent.day = 7
            self.date = Calendar.current.date(byAdding: dateComponent, to: self.date) ?? Date()
            self.setupData()
        }
        self.btnDate1.action = {
            self.selectedDate = self.startOfWeek
            self.setupData()
            self.getVisiteList_APICall()
        }
        self.btnDate2.action = {
            var dateComponent = DateComponents()
            dateComponent.day = 1
            self.selectedDate = Calendar.current.date(byAdding: dateComponent, to: self.startOfWeek) ?? Date()
            self.setupData()
            self.getVisiteList_APICall()
        }
        self.btnDate3.action = {
            var dateComponent = DateComponents()
            dateComponent.day = 2
            self.selectedDate = Calendar.current.date(byAdding: dateComponent, to: self.startOfWeek) ?? Date()
            self.setupData()
            self.getVisiteList_APICall()
        }
        self.btnDate4.action = {
            var dateComponent = DateComponents()
            dateComponent.day = 3
            self.selectedDate = Calendar.current.date(byAdding: dateComponent, to: self.startOfWeek) ?? Date()
            self.setupData()
            self.getVisiteList_APICall()
        }
        self.btnDate5.action = {
            var dateComponent = DateComponents()
            dateComponent.day = 4
            self.selectedDate = Calendar.current.date(byAdding: dateComponent, to: self.startOfWeek) ?? Date()
            self.setupData()
            self.getVisiteList_APICall()
        }
        self.btnDate6.action = {
            var dateComponent = DateComponents()
            dateComponent.day = 5
            self.selectedDate = Calendar.current.date(byAdding: dateComponent, to: self.startOfWeek) ?? Date()
            self.setupData()
            self.getVisiteList_APICall()
        }
        self.btnDate7.action = {
            var dateComponent = DateComponents()
            dateComponent.day = 6
            self.selectedDate = Calendar.current.date(byAdding: dateComponent, to: self.startOfWeek) ?? Date()
            self.setupData()
            self.getVisiteList_APICall()
        }
        selectedDate = Date()
        date = Date()
        self.setupData()
      
        imageView = UIImageView(frame: CGRect(x: 90, y: tableView.frame.origin.y, width:  self.view.frame.width - 180, height:  tableView.frame.height - 100))
        imageView?.isHidden = true
        imageView?.image = UIImage(named: "noData")
        imageView?.contentMode = .scaleAspectFit
       // self.view.addSubview(imageView!)
        
        // do not using force for adding imageview  like this
        
        if let imageView = imageView {
            self.view.addSubview(imageView)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {[weak self] in
            self?.getVisiteList_APICall()
        })
    }
    func setupData() {
        let views = [viewDate1, viewDate2, viewDate3, viewDate4, viewDate5, viewDate6, viewDate7]
        let labels = [lblDate1, lblDate2, lblDate3, lblDate4, lblDate5, lblDate6, lblDate7]
        
        for view in views {
            setupUnselected(view: view!)
        }
        
        // Find the Sunday of the current week
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: self.date)
        self.startOfWeek = calendar.date(byAdding: .day, value: -(weekday - 2), to: self.date)!

        for i in 0..<7 {
            if let newDate = calendar.date(byAdding: .day, value: i, to: self.startOfWeek) {
                let day = convertDateToString(date: newDate, format: "EEE")
                
                let date = convertDateToString(date: newDate, format: "dd")
                labels[i]?.text = day.prefix(2) + "\n\n" + date
                if calendar.isDate(newDate, inSameDayAs: self.selectedDate) {
                    setupSelected(view: views[i]!)
                }
            }
        }
        
        if let endDate = Calendar.current.date(byAdding: .day, value: 6, to: self.startOfWeek) {
            lblMonth.text = convertDateToString(date: self.startOfWeek, format: "MMMM dd") + " to " + convertDateToString(date: endDate, format: "MMMM dd yyyy")
        }
    }

    func setupSelected(view:AGView){
        view.backgroundColor = UIColor(named: "appGreen")
        view.borderWidth = 0
        for t in view.subviews{
            if let ttt = t as? UILabel{
                ttt.textColor = .white
            }
        }
    }
    func setupUnselected(view:AGView){
        view.backgroundColor = .clear
        view.borderWidth = 2
        for t in view.subviews{
            if let ttt = t as? UILabel{
                ttt.textColor = .black
            }
        }
    }
}

extension VisitsViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int{
        return self.list.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == self.list.count - 1 {
            return self.list[section].data.count
        } else if self.list[section].isExpand {
            return self.list[section].data.count
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if list[section].data.count == 0 {
            return 0
        }
        if list.count == section + 1 {
            return 0
        }
        return 55
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        let cell = tableView.dequeueReusableCell(withClassIdentifier: VisitsSectionTableCell.self)
        cell.setupData(model: self.list[section])
        cell.clickHandler = {
            self.list[section].isExpand = !self.list[section].isExpand
            self.tableView.reloadData()
        }
        self.tableView.layoutSubviews()
        return cell
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.list[indexPath.section].type == .completed {
            let cell = tableView.dequeueReusableCell(withClassIdentifier: CompletedVisitsTableCell.self,for: indexPath)
            cell.setupData(model: self.list[indexPath.section].data[indexPath.row])
            self.tableView.layoutSubviews()
            return cell
        }else if self.list[indexPath.section].type == .onging {
            let cell = tableView.dequeueReusableCell(withClassIdentifier: OngoingVisitsTableCell.self,for: indexPath)
            cell.setupData(model: self.list[indexPath.section].data[indexPath.row])
            self.tableView.layoutSubviews()
            return cell
        }else if self.list[indexPath.section].type == .upcoming {
            let cell = tableView.dequeueReusableCell(withClassIdentifier: UpcomingVisitsTableCell.self,for: indexPath)
            cell.ongoingCount = self.list.first { $0.type == .onging }?.data.count ?? 0
            if indexPath.row == self.list[indexPath.section].data.count - 1 {
                cell.setupData(model: self.list[indexPath.section].data[indexPath.row],
                               isLast: true)
            } else {
                cell.setupData(model: self.list[indexPath.section].data[indexPath.row],
                               isLast: false, placeID: self.list[indexPath.section].data[indexPath.row + 1].placeID)
            }
           
            self.tableView.layoutSubviews()
            return cell
        }else if self.list[indexPath.section].type == .notcompleted {
            let cell = tableView.dequeueReusableCell(withClassIdentifier: NotCompletedVisitsTableCell.self,for: indexPath)
            cell.setupData(model: self.list[indexPath.section].data[indexPath.row])
            self.tableView.layoutSubviews()
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.list[indexPath.section].type == .onging{
            if self.list[indexPath.section].data[indexPath.row].visitType == "Unscheduled"{
                let vc = Storyboard.Visits.instantiateViewController(withViewClass: UnscheduleViewController.self)
                vc.visit =  self.list[indexPath.section].data[indexPath.row]
                vc.visitType = self.list[indexPath.section].type
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = Storyboard.Visits.instantiateViewController(withViewClass: ScheduleViewController.self)
                vc.visit =  self.list[indexPath.section].data[indexPath.row]
                vc.visitType = self.list[indexPath.section].type
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if self.list[indexPath.section].type == .completed{
            if self.list[indexPath.section].data[indexPath.row].visitType == "Unscheduled"{
                let vc = Storyboard.Visits.instantiateViewController(withViewClass: UnscheduleViewController.self)
                vc.visit =  self.list[indexPath.section].data[indexPath.row]
                vc.visitType = self.list[indexPath.section].type
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = Storyboard.Visits.instantiateViewController(withViewClass: ScheduleViewController.self)
                vc.visit =  self.list[indexPath.section].data[indexPath.row]
                vc.visitType = self.list[indexPath.section].type
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}


// MARK: API Call
extension VisitsViewController {
    
    func alert(model: [VisitsModel]) {
        return
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(model)
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("JSON Output:")
                print(jsonString)
                
                let alert = UIAlertController(title: "This text share with us", message: jsonString, preferredStyle: .alert)
                
                // Copy action
                let copyAction = UIAlertAction(title: "Copy", style: .default) { _ in
                    UIPasteboard.general.string = jsonString
                    print("Text copied to clipboard")
                }
                
                // Cancel action
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                
                alert.addAction(copyAction)
                alert.addAction(cancelAction)
                
                present(alert, animated: true)
            }
        } catch {
            print("Error encoding JSON: \(error.localizedDescription)")
        }
    }
    
    private func getVisiteList_APICall() {
        
        let s = convertDateToString(date:selectedDate, format: "yyyy-MM-dd")
        //s = "2025-02-03"
        WebServiceManager.sharedInstance.callAPI(apiPath: .getVisitList(userId: UserDetails.shared.user_id),queryParams: [APIParameters.Visits.visitDate: s], method: .get, params: [:],isAuthenticate: true, model: CommonRespons<[VisitsModel]>.self) { response, successMsg in
            self.scroll.endRefreshing()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in

                    if data.statusCode == 200{
                        
                        var completed:[VisitsModel] = []
                        var notcompleted:[VisitsModel] = []
                        var ongoing:[VisitsModel] = []
                        var upcomeing:[VisitsModel] = []
                        
                        for t in data.data ?? []{
                            if (t.actualStartTime?.first ?? "").isEmpty && (t.actualEndTime?.first ?? "").isEmpty{
                                let datetime = "\(t.visitDate ?? "") \(t.plannedStartTime ?? "")"
                                if let createdAt = convertStringToDate(dateString: datetime, format: "yyyy-MM-dd HH:mm") {
                                    let now = Date()
                                    let hoursDifference = Calendar.current.dateComponents([.hour], from: createdAt, to: now).hour ?? 0
                                    if hoursDifference >= 4 {
                                        notcompleted.append(t)
                                    } else {
                                        upcomeing.append(t)
                                    }
                                } else {
                                    upcomeing.append(t)
                                }
                            }else if !(t.actualStartTime?.first ?? "").isEmpty && (t.actualEndTime?.first ?? "").isEmpty{
                                ongoing.append(t)
                            }else if !(t.actualStartTime?.first ?? "").isEmpty && !(t.actualEndTime?.first ?? "").isEmpty{
                                completed.append(t)
                            }
                        }
                        let currentC = self?.list.first { $0.type == .completed }?.isExpand ?? false
                        let currentO = self?.list.first { $0.type == .onging }?.isExpand ?? false
                        let currentU = self?.list.first { $0.type == .upcoming }?.isExpand ?? false
                        let currentNC = self?.list.first { $0.type == .notcompleted }?.isExpand ?? false
                        
                        self?.list = [VisitsSectionModel(title:"Not Completed Visits",
                                                        type:.notcompleted,
                                                         isExpand: currentNC,
                                                        data: notcompleted),
                                     VisitsSectionModel(title:"Completed Visits",
                                                        type:.completed,isExpand: currentC,
                                                        data: completed),
                                     VisitsSectionModel(title:"Ongoing Visits",
                                                        type:.onging,
                                                        isExpand: currentO,
                                                        data: ongoing),
                                     VisitsSectionModel(title:"Upcoming Visits",
                                                        type:.upcoming,
                                                        isExpand: currentU,
                                                        data: upcomeing)]
                        self?.alert(model: upcomeing)

                        self?.tableView.reloadData()
                        self?.tableView.isHidden = false
                        self?.imageView?.isHidden = true
                        if upcomeing.count == 0 && ongoing.count == 0 && completed.count == 0 && notcompleted.count == 0 {
                            self?.tableView.isHidden = true
                            self?.imageView?.isHidden = false
                        }
                    } else {
                        self?.view.makeToast(data.message ?? "")
//                        self.list = [VisitsSectionModel(title:"Not Completed Visits",type:.notcompleted),VisitsSectionModel(title:"Completed Visits",type:.completed),VisitsSectionModel(title:"Ongoing Visits",type:.onging),VisitsSectionModel(title:"Upcoming Visits",type:.upcoming)]
                        self?.list = []
                        self?.tableView.reloadData()
                        self?.tableView.isHidden = self?.list.count == 0
                        self?.imageView?.isHidden = self?.list.count != 0
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {[weak self] in
                    self?.view.makeToast(error.localizedDescription)
                    self?.list = []
                    self?.tableView.reloadData()
                    self?.tableView.isHidden = self?.list.count == 0
                    self?.imageView?.isHidden = self?.list.count != 0
                }
            }
        }
    }
    
    private func getNotoficationList_APICall() {
        
        CustomLoader.shared.showLoader(on: self.view)
        WebServiceManager.sharedInstance.callAPI(apiPath: .getallnotifications(userId: UserDetails.shared.user_id), method: .get, params: [:],isAuthenticate: true, model: CommonRespons<[NotificationModel]>.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {
                    if data.statusCode == 200{
                        let array = data.data ?? []
                        notificationCount = array.count
                           // You can include an optional userInfo dictionary to pass data
                        NotificationCenter.default.post(name: .customNotification,
                                                        object: nil,
                                                        userInfo: ["message": "Data from the sender!",
                                                                   "count": array.count])
                      

                    }
                }

            case .failure(_):
                print("no code")
            }
        }
    }

}



