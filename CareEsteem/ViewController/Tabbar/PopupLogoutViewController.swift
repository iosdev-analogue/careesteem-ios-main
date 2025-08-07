//
//  PopupLogoutViewController.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 13/03/25.
//


import UIKit

class PopupLogoutViewController: UIViewController {

    @IBOutlet weak var btnClose: AGButton!
    @IBOutlet weak var btnConfirm: AGButton!
    var confirmHandler:(()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnClose.action = {
            self.dismiss(animated: true)
        }
        self.btnConfirm.action = {
            self.dismiss(animated: true){
                self.confirmHandler?()
            }
        }
    }
}
