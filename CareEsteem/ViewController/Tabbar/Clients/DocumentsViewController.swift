//
//  DocumentsViewController.swift
//  CareEsteem
//
//  Created by Nitin Chauhan on 22/06/25.
//

import UIKit
import WebKit

class DocumentsViewController: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnClose: AGButton!
    @IBOutlet weak var tableView: UITableView!
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

extension DocumentsViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return expendedArray[section] ? docArray[section].attachDocument.count + 1 : 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return docArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withClassIdentifier: DocumentsTableViewCell.self)
            
            let model = self.docArray[indexPath.section]
            cell.nameLbl.text = model.documentName
            cell.iv.image = UIImage(named: "vector")
            cell.button.setImage(UIImage(named: "eye"), for: .normal)
            if expendedArray[indexPath.section] {
                cell.button.setImage(UIImage(systemName: "chevron.up"), for: .normal)

//                self.imgDropDown.image = UIImage(systemName: "chevron.up")
            }else{
                cell.button.setImage(UIImage(systemName: "chevron.down"), for: .normal)

//                self.imgDropDown.image = UIImage(systemName: "chevron.down")
            }
            cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.width, bottom: 0, right: 0)
            self.tableView.layoutSubviews()

            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withClassIdentifier: DocumentsTableViewCell.self,
                                                 for: indexPath)
        
        let model: AttachDocument = self.docArray[indexPath.section].attachDocument[indexPath.row - 1]
        cell.nameLbl.text = model.filename
        cell.iv.image = UIImage(named: "doc")
        cell.button.setImage(UIImage(named: "eye"), for: .normal)
        cell.clickHandler = {
            self.dismiss(animated: true, completion: {
                let vc = Storyboard.Clients.instantiateViewController(withViewClass: WebViewController.self)
                vc.url =  model.url
                AppDelegate.shared.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            })
           
//            if let url = URL(string: model.url) {
//                UIApplication.shared.open(url)
//            }
        }
        cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.width, bottom: 0, right: 0)
        self.tableView.layoutSubviews()

        return cell
    }
    

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            return
        }
        
        self.expendedArray[indexPath.section] = !self.expendedArray[indexPath.section]
        tableView.reloadData()
    }
}

