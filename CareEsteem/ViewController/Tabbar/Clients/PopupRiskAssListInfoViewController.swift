//
//  PopupRiskAssListInfoViewController.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 08/03/25.
//


import UIKit

class PopupRiskAssListInfoViewController: UIViewController {

    @IBOutlet weak var getView: AGView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnClose: AGButton!
    @IBOutlet weak var tableView: UITableView!
    var list:[RiskAssesstment] = []
    var titleStr:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblTitle.text = self.titleStr
        self.btnClose.action = {
            self.dismiss(animated: true)
        }
        self.tableView.reloadData()
    }

}
extension PopupRiskAssListInfoViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClassIdentifier: InfoHstackTableViewCell.self,for: indexPath)
        cell.setupData(model: self.list[indexPath.row])
        if self.list.count-1 == indexPath.row{
            cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.width, bottom: 0, right: 0)
        }
        return cell
    }
}
