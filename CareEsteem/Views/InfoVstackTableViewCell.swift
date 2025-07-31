//
//  InfoVstackTableViewCell.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 09/03/25.
//


import UIKit
class InfoVstackTableViewCell:UITableViewCell{
    
    @IBOutlet weak var lblIndex: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValue: UILabel!
  
    func setupData(model:MyPopupListModel){
        self.lblTitle.text = model.title
        self.lblValue.text = model.value
    }
}
