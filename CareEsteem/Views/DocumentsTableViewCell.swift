//
//  DocumentsTableViewCell.swift
//  CareEsteem
//
//  Created by Nitin Chauhan on 22/06/25.
//

import UIKit

class DocumentsTableViewCell: UITableViewCell {

    @IBOutlet weak var button: AGButton!
    @IBOutlet weak var iv: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    var clickHandler:(()->Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func buttonAction(_ sender: Any) {
        self.clickHandler?()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
