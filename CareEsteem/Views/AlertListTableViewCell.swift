//
//  AlertListTableViewCell.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 09/03/25.
//


import UIKit
class AlertListTableViewCell:UITableViewCell{
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var detailView: UIStackView!
    @IBOutlet weak var lblClientName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblSeverityOfConcern: UILabel!
    @IBOutlet weak var txtConcernDetail: UITextView!
    @IBOutlet weak var imgDropDown: UIImageView!
    
    @IBOutlet weak var tableView: AGTableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    var model:AlertModel? = nil
    
    func setupData(model:AlertModel){
        tableView.dataSource = self
        tableView.delegate = self
        let createdAt = convertStringToDate(dateString: model.createdAt ?? "", format: "yyyy-MM-dd'T'HH:mm:ss.SSS")
        self.lblName.text = (model.clientName ?? "") + "  " + convertDateToString(date: createdAt ?? Date(), format: "dd/MM/yyyy 'at' hh:mm a", timeZone: TimeZone(identifier: "Europe/London"))
        if model.isExpand ?? false{
            tableViewHeight.constant = CGFloat((model.bodyPartNames?.count ?? 0) * 300)
            self.imgDropDown.image = UIImage(systemName: "chevron.up")
            self.detailView.isHidden = false
        }else{
            tableViewHeight.constant = 0
            self.imgDropDown.image = UIImage(systemName: "chevron.down")
            self.detailView.isHidden = true
        }
        self.lblClientName.text = model.clientName
        self.lblTime.text = model.sessionTime
        self.lblSeverityOfConcern.text = model.severityOfConcern
        self.txtConcernDetail.text = model.concernDetails
        self.model = model
        tableView.reloadData()
    }
}

extension AlertListTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.isExpand ?? false ? model?.bodyPartNames?.count ?? 0 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClassIdentifier: BodyPartSelectedTableCell.self,for: indexPath)
        cell.setupData(name: model?.bodyPartNames?[indexPath.row], imageUrl:  model?.bodyImage?[indexPath.row] ?? "")
        return cell
    }
}
