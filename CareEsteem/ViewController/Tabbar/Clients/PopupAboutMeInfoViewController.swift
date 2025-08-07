//
//  PopupAboutMeInfoViewController.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 09/03/25.
//


import UIKit

class PopupAboutMeInfoViewController: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnClose: AGButton!
    @IBOutlet weak var tableView: UITableView!
    var list:[[MyPopupListModel]] = []
    var docArray: [Documents] = []
    var titleStr:String = ""
    var expendedArray: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in docArray {
            expendedArray.append(false)
        }
        self.lblTitle.text = self.titleStr
        self.btnClose.action = {
            self.dismiss(animated: true)
        }
        self.tableView.reloadData()
    }
    
}
extension PopupAboutMeInfoViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if list.count == 0 {
            return expendedArray[section] ? docArray[section].attachDocument.count : 0
        }
        return self.list.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        if list.count == 0 {
            return docArray.count
        }
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if list.count == 0 {
            let cell = tableView.dequeueReusableCell(withClassIdentifier: DocumentsTableViewCell.self,
                                                     for: indexPath)
           
            let model: AttachDocument = self.docArray[indexPath.section].attachDocument[indexPath.row]
            cell.nameLbl.text = model.filename
            cell.iv.image = UIImage(named: "doc")
            cell.button.setImage(UIImage(named: "eye"), for: .normal)
            cell.clickHandler = {
                if let url = URL(string: model.url) {
                    UIApplication.shared.open(url)
                }
            }
            cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.width, bottom: 0, right: 0)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withClassIdentifier: InfoAboutStackTableViewCell.self,for: indexPath)
        cell.setupData(model: self.list[indexPath.row])
        cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.width, bottom: 0, right: 0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        if list.count == 0 {
            let cell = tableView.dequeueReusableCell(withClassIdentifier: DocumentsTableViewCell.self)
           
            let model = self.docArray[section]
            cell.nameLbl.text = model.documentName
            cell.iv.image = UIImage(named: "vector")
            cell.clickHandler = {
                self.expendedArray[section] = !self.expendedArray[section]
                tableView.reloadData()
//                if let url = URL(string: model.fileUrl ?? "") {
//                    UIApplication.shared.open(url)
//                }
            }
            cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.width, bottom: 0, right: 0)
            return cell
        }
        return UIView()

    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if list.count == 0 {
            return 45
        }
        return 0
    }
}
