//
//  ProfileViewController.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 13/03/25.
//

import UIKit
import UserNotifications

class ProfileViewController: UIViewController {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAgency: UILabel!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var lblContactNumber: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblPostCode: UILabel!
 
    @IBOutlet weak var profileSwitch: UISwitch!
    @IBOutlet weak var lblVersion: UILabel!
    @IBOutlet weak var btnLogout: AGButton!
    
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var imgProfile: AGImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupData()
        self.getProfile_APICall()
        self.btnLogout.action = {
            let vc = Storyboard.Main.instantiateViewController(withViewClass: PopupLogoutViewController.self)
            vc.confirmHandler = {
                UserDetails.shared.loginModel = nil
                UserDefaults.standard.removeObject(forKey: "loginModel")
                let vc = Storyboard.Login.instantiateViewController(withViewClass: LoginViewController.self)
                let navi = CustomNavigationController(rootViewController: vc)
                navi.isNavigationBarHidden = true
                AppDelegate.shared.window?.rootViewController = navi
            }
            vc.transitioningDelegate = customTransitioningDelegate
            vc.modalPresentationStyle = .custom
            self.present(vc, animated: true)
        }
        self.lblVersion.text = "Version "+Application.appVersion+"(\(Application.appBuild))"
    }
    func setupData() {
        if let profile = UserDetails.shared.profileModel{
            self.lblName.text = profile.name
            self.lblAgency.text = profile.agency
            self.lblAge.text = profile.age?.description
            self.lblContactNumber.text = profile.contactNumber
            self.lblEmail.text = profile.email
            self.lblAddress.text = profile.address
            self.lblCity.text = profile.city
            self.lblPostCode.text = profile.postcode
            self.imgProfile.image = profile.profilePhoto?.base64ToUIImage() ?? UIImage(named: "logo")
        } else {
            self.lblName.text = ""
            self.lblAgency.text = ""
            self.lblAge.text = ""
            self.lblContactNumber.text = ""
            self.lblEmail.text = ""
            self.lblAddress.text = ""
            self.lblCity.text = ""
            self.lblPostCode.text = ""
        }
        profileSwitch.isUserInteractionEnabled = true
        notificationSwitch.isEnabled = false
 
        
        if UserDefaults.standard.bool(forKey: "isfaceIDOn"){
            profileSwitch.setOn(true, animated: true)
        }else{
            profileSwitch.setOn(false, animated: true)
        }
        
        hasNotificationPermission(completion: { status in
            DispatchQueue.main.async {[weak self] in
                self?.notificationSwitch.setOn(status, animated: true)
            }
        })
    }
    
    @IBAction func toggle(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "isfaceIDOn")
        UserDefaults.standard.synchronize()
        if sender.isOn {
            stepRecordText = ""
        } else {
//            self.showAlert()
        }
    }
    
    private func hasNotificationPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            completion(settings.authorizationStatus == .authorized)
        }
    }
    
    @IBAction func btnSwitchAccount(_ sender : UIButton){
        AppDelegate.shared.logOut()
    }


    func showAlert() {
            let alert = UIAlertController(title: "Alert", message: stepRecordText, preferredStyle: .alert)
            
            // Copy action
            let copyAction = UIAlertAction(title: "Copy", style: .default) { _ in
                UIPasteboard.general.string = stepRecordText
                print("Text copied to clipboard")
            }
            
            // Cancel action
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            alert.addAction(copyAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true)
        }

}
// MARK: API Call
extension ProfileViewController {
    
    private func getProfile_APICall() {
        
        WebServiceManager.sharedInstance.callAPI(apiPath: .getAllUsers(userId: UserDetails.shared.user_id), method: .get, params: [:],isAuthenticate: true, model: CommonRespons<[ProfileModel]>.self) { response, successMsg in
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        UserDetails.shared.profileModel = data.data?.first
                        self?.setupData()
                    }else{
                        self?.view.makeToast(data.message ?? "")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {[weak self] in
                    self?.view.makeToast(error.localizedDescription)
                }
            }
        }
    }
}


