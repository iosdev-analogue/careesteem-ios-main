//
//  ConfirmPinVC.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 07/03/25.
//


import UIKit
import PinCodeInputView
class ConfirmPinVC: UIViewController {

    @IBOutlet weak var vwTextField: UIView!
    var setPin = ""
    var otp = ""
    let pinCodeInputView: PinCodeInputView<PasswordItemView> = .init(
        digit: 4,
        itemSpacing: 15,
        itemFactory: {
            return PasswordItemView()
        })
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {[weak self] in
            self?.setUpUI()
        })
    }

    private func setUpUI() {
        
        vwTextField.addSubview(pinCodeInputView)
    
        pinCodeInputView.frame = vwTextField.bounds
        pinCodeInputView.isUserInteractionEnabled = false
        
        pinCodeInputView.set(changeTextHandler: { text in
            if text.count > 3 {
                if self.setPin == text{
                    if self.otp.isEmpty{
                        DispatchQueue.main.async(execute: {[weak self] in
                            self?.addPasscode_APICall(passcode: text)
                        })
                    }else{
                        self.resetPasscode_APICall(passcode: text)
                    }
                }else{
                    self.view.makeToast("Set Pin and confirm pin does not match.")
                }
            }
        })
        
        pinCodeInputView.set(
            appearance: .init(
                itemSize: CGSize(width: 12, height: 12),
                font: .systemFont(ofSize: 28, weight: .bold),
                textColor: UIColor(named: "appGreen") ?? .green,
                backgroundColor: UIColor.blue.withAlphaComponent(0.3),
                cursorColor: UIColor(named: "appGreen") ?? .green,
                cornerRadius: 8
            )
        )
        let keyboard = CustomKeyboardView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-32, height: self.view.frame.width-32))
        keyboard.keyPressed = { pin in
            if pin == "⌫"{
                self.pinCodeInputView.deleteBackward()
            }else{
                self.pinCodeInputView.insertText(pin)
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
            pinCodeInputView.set(text: string)
        }
    }
    
    @objc func tap() {
        pinCodeInputView.resignFirstResponder()
    }
    
}
// MARK: API Call
extension ConfirmPinVC {
    private func addPasscode_APICall(passcode:String) {
        let params = [APIParameters.Login.contactNumber: UserDetails.shared.loginModel?.contactNumber ?? "",
                      APIParameters.Login.passcode: passcode]
        CustomLoader.shared.showLoader(on: self.view)
        WebServiceManager.sharedInstance.callAPI(apiPath: .createPasscode, method: .post, params: params,isAuthenticate: true, model: CommonRespons<SetPinModel>.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        UserDetails.shared.loginModel?.passcode = passcode
                        AppDelegate.shared.SetTabBarMainView()
                        DispatchQueue.main.async {
                            AppDelegate.shared.window?.makeToast(data.message ?? "")
                        }
                    }else{
                        self?.view.makeToast(data.message ?? "")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    self?.view.makeToast(error.localizedDescription)
                }
            }
        }
    }
    private func resetPasscode_APICall(passcode:String) {
        let params = [APIParameters.Login.contactNumber: UserDetails.shared.loginModel?.contactNumber ?? "",
                      APIParameters.Login.passcode: passcode,
                      APIParameters.Login.otp: self.otp
                ]
        CustomLoader.shared.showLoader(on: self.view)
        WebServiceManager.sharedInstance.callAPI(apiPath: .resetPasscode, method: .post, params: params,isAuthenticate: true, model: CommonRespons<[LoginUserModel]>.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        self?.view.makeToast(data.message ?? "")
                        UserDetails.shared.loginModel = data.data?.first
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
}
