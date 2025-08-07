//
//  EnterYourPinVC.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 07/03/25.
//

import UIKit
import PinCodeInputView
import LocalAuthentication

var universalFaceID = false

class EnterYourPinVC: UIViewController {

    @IBOutlet weak var vwTextField: UIView!
    @IBOutlet weak var btnForget:AGButton!
    
    weak var pinCodeInputView: PinCodeInputView<PasswordItemView>? = .init(
        digit: 4,
        itemSpacing: 15,
        itemFactory: {
            return PasswordItemView()
        })
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.removeFromSuperview()
        view = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {[weak self] in
            self?.setUpUI()
        })
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        self.btnForget.action = {
//            self.forgetPasscode_APICall()
            UserDetails.shared.loginModel = nil
            UserDefaults.standard.removeObject(forKey: "loginModel")
            let vc = Storyboard.Login.instantiateViewController(withViewClass: LoginViewController.self)
            let navi = CustomNavigationController(rootViewController: vc)
            navi.isNavigationBarHidden = true
            AppDelegate.shared.window?.rootViewController = navi
        }
    }

    private func setUpUI() {
        
        vwTextField.addSubview(pinCodeInputView!)
        pinCodeInputView?.isUserInteractionEnabled = false
        
        pinCodeInputView?.set(changeTextHandler: { text in
            if text.count > 3 {
                DispatchQueue.main.async {[weak self] in
                    self?.verifyPasscode_APICall(passcode: text)
                }
            }
        })
        
        pinCodeInputView?.set(
            appearance: .init(
                itemSize: CGSize(width: 12, height: 12),
                font:UIFont.robotoSlab(.bold, size: 25)
                  //  UIFont(name: "RobotoSlab-Regular", size: 25) ?? UIFont.systemFont(ofSize: 25)
                ,
                textColor: UIColor(named: "appGreen") ?? .green,
                backgroundColor: UIColor.blue.withAlphaComponent(0.3),
                cursorColor: UIColor(named: "appGreen") ?? .green,
                cornerRadius: 8
            )
        )
        pinCodeInputView?.frame = CGRect(x: 0, y: 0, width: vwTextField.frame.width, height: vwTextField.frame.height)
        if UserDefaults.standard.bool(forKey: "isfaceIDOn") {
            universalFaceID = true
        }
        let keyboard = CustomKeyboardView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-32, height: self.view.frame.width-32))
        universalFaceID = false
        keyboard.keyPressed = { pin in
            if pin == "☑" {
                self.authenticateWithFaceID(completion: {status, msg in
                    if status {
                        AppDelegate.shared.SetTabBarMainView()
                    } else {
                        self.view.makeToast(msg)
                    }
                    
                })
            }else if pin == "⌫"{
                self.pinCodeInputView?.deleteBackward()
            }else{
                self.pinCodeInputView?.insertText(pin)
            }
        }
        view.addSubview(keyboard)
        keyboard.translatesAutoresizingMaskIntoConstraints = false
        
        let ff = self.view.viewWithTag(8)
        NSLayoutConstraint.activate([
            keyboard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            keyboard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            keyboard.topAnchor.constraint(equalTo: ff!.bottomAnchor, constant: 50),
        ])
    }
    
    @objc func didBecameActive() {
        if let string = UIPasteboard.general.string {
            pinCodeInputView?.set(text: string)
        }
    }
    
    @objc func tap() {
        pinCodeInputView?.resignFirstResponder()
    }
    
}

// MARK: API Call
extension EnterYourPinVC {
    private func verifyPasscode_APICall(passcode:String) {
        let params = [APIParameters.Login.contactNumber: UserDetails.shared.loginModel?.contactNumber ?? "",
                      APIParameters.Login.passcode: passcode,
                ]
        CustomLoader.shared.showLoader(on: self.view)
        WebServiceManager.sharedInstance.callAPI(apiPath: .verifyPasscode, method: .post, params: params,isAuthenticate: true, model: EmptyReponse.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        AppDelegate.shared.SetTabBarMainView()
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
    private func forgetPasscode_APICall() {
        let params = [APIParameters.Login.contactNumber: UserDetails.shared.loginModel?.contactNumber ?? "",
                      APIParameters.Login.telephoneCodes:UserDetails.shared.loginModel?.telephoneCodes ?? 0,
        ] as [String : Any]
        CustomLoader.shared.showLoader(on: self.view)
        WebServiceManager.sharedInstance.callAPI(apiPath: .forgotPasscode, method: .post, params: params,isAuthenticate: true, model: CommonRespons<LoginUserModel>.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        let vc = Storyboard.Login.instantiateViewController(withViewClass: SecurityCodeViewController.self)
                        vc.isForget = true
                        vc.userModel = data.data
                        self?.navigationController?.pushViewController(vc, animated: true)
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

extension EnterYourPinVC {
    func authenticateWithFaceID(completion: @escaping (Bool, String?) -> Void) {
        let context = LAContext()
        var error: NSError?

        // Check if device supports Face ID
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate with Face ID"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async { [weak self] in
                    if success {
                        completion(true, nil)
                    } else {
                        let message = authenticationError?.localizedDescription ?? "Failed to authenticate"
                        completion(false, message)
                    }
                }
            }
        } else {
            let message = error?.localizedDescription ?? "Face ID not available"
            completion(false, message)
        }
    }
}
