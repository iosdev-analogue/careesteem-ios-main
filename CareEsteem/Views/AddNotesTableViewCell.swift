//
//  AddNotesTableViewCell.swift
//  CareEsteem
//
//  Created by Nitin Chauhan on 22/07/25.
//

import UIKit

class AddNotesTableViewCell: UITableViewCell {
    @IBOutlet weak var button: AGButton!
    var clickHandler:(()->Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.button.action = {
            self.clickHandler?()
        }
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
