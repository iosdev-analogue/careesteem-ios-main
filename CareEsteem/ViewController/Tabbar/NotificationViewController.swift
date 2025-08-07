//
//  NotificationViewController.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 07/03/25.
//

import UIKit

class NotificationViewController: UIViewController {

    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var noSubTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var list:[NotificationModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.noDataView.isHidden = false
        self.lblAttribute()
        self.getNotoficationList_APICall()
    }
    func lblAttribute() {

        let boldText1 = "notified"
        let boldText2 = "your schedule"
        let normalText = "You will be "
        let normalText1 = " if there are any changes to "
       
        let normalAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.loraFont(size: 15, weight: .Regular),
            .foregroundColor: UIColor(named: "appDarkText") ?? .black
        ]
        let normalString = NSMutableAttributedString(string: normalText, attributes: normalAttrs)
        
        let boldAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.loraFont(size: 15, weight: .Regular),
            .foregroundColor: UIColor(named: "appGreen") ?? .green
        ]
        
        let attributedString1 = NSMutableAttributedString(string: boldText1, attributes: boldAttrs)
        let attributedString2 = NSMutableAttributedString(string: boldText2, attributes: boldAttrs)
        
        normalString.append(attributedString1)
        normalString.append(NSMutableAttributedString(string: normalText1, attributes: normalAttrs))
        normalString.append(attributedString2)
        
        noSubTitle.attributedText = normalString

    }

    @IBAction func btnClearAllAction(_ sender:UIButton){
        self.list = []
        self.tableView.reloadData()
    }
}
extension NotificationViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClassIdentifier: NotificationListTableViewCell.self,for: indexPath)
        cell.setupData(model: self.list[indexPath.row])
        return cell
    }
}

// MARK: API Call
extension NotificationViewController {
    
    private func getNotoficationList_APICall() {
        
        CustomLoader.shared.showLoader(on: self.view)
        WebServiceManager.sharedInstance.callAPI(apiPath: .getallnotifications(userId: UserDetails.shared.user_id), method: .get, params: [:],isAuthenticate: true, model: CommonRespons<[NotificationModel]>.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        self?.list = data.data ?? []
                        self?.noDataView.isHidden = !(self?.list.isEmpty ?? false)
                        self?.tableView.reloadData()
                    }else{
                        self?.noDataView.isHidden = !(self?.list.isEmpty ?? false)
                        self?.view.makeToast(data.message ?? "")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {[weak self] in
                    self?.noDataView.isHidden = !self!.list.isEmpty
                    self?.view.makeToast(error.localizedDescription)
                }
            }
        }
    }
}


