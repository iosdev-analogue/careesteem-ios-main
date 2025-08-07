//
//  PopupDisplayListInfoViewController.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 08/03/25.
//

import UIKit

class PopupDisplayListInfoViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnClose: AGButton!
    @IBOutlet weak var tableView: UITableView!
    var list:[MyPopupListModel] = []
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
extension PopupDisplayListInfoViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClassIdentifier: InfoVstackTableViewCell.self,for: indexPath)
        cell.setupData(model: self.list[indexPath.row])
        cell.lblIndex.text = "\(indexPath.row+1)."
        return cell
    }
}
