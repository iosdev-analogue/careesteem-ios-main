//
//  SecurityCodeViewController.swift
//  careesteem
//
//  Created by Gaurav Gudaliya on 07/03/25.
//

import UIKit

class SecurityCodeViewController: UIViewController {
    
    @IBOutlet weak var btnVerifyOTP:AGButton!
    @IBOutlet weak var btnReSendOtp:AGButton!
    @IBOutlet weak var btnTCAgree:AGButton!
    @IBOutlet weak var viewReSendOtp:UIView!
    @IBOutlet weak var otpView: VPMOTPView!
    @IBOutlet weak var lblTermAndCondition: UILabel!
    @IBOutlet weak var lblText:UILabel!
    
    var enteredOtp: String = ""
 
    var userModel: LoginUserModel?
    var mobile: String?
    var countryID: String?
    var countyCode: String?
    var totalTime = 60
    var countdownTimer: Timer!

    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    var isForget = false
 
    override func viewDidLoad() {
        super.viewDidLoad()
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
        let mobile = "+" + (countyCode ?? "") + " " + (mobile ?? "")
        self.lblText.text = "OTP sent to \(mobile.maskPhoneNumber())"
        self.btnVerifyOTP.disbledButton()
        otpView.backgroundColor = UIColor.clear
        otpView.otpFieldsCount = 6
        otpView.otpFieldDefaultBorderColor = UIColor(named: "appGreen") ?? .green
        otpView.otpFieldBorderWidth = 2
        otpView.otpFieldDefaultBackgroundColor = UIColor.white
        otpView.otpFieldEnteredBorderColor = UIColor(named: "appGreen") ?? .green
        otpView.otpFieldEnteredBackgroundColor = UIColor.white
        otpView.otpFieldSeparatorSpace = (otpView.frame.width-((otpView.frame.height-5)*6))/6
        otpView.otpFieldSize = otpView.frame.height-5
        otpView.delegate = self
        otpView.otpFieldFont = UIFont.init(name: "AvenirLTStd-Black", size: 25.0) ?? UIFont.boldSystemFont(ofSize: 25)
        otpView.shouldAllowIntermediateEditing = true
        self.lblTermAndConditionAttribute()
        
        btnVerifyOTP.action = {
            if self.enteredOtp.count != 6 {
                self.otpView.initializeUI()
                self.otpView.shake()
            }
            else{
                self.verifyOTP_APICall()
            }
        }
        
        btnReSendOtp.action = {
            if self.isForget{
                self.forgetPasscode_APICall()
            }else{
                if let title = self.btnReSendOtp.titleLabel?.text, title == "Resend OTP" {
                    self.sendOTP_APICall()
                }
            }
            
        }
        self.btnTCAgree.action = {
            self.btnTCAgree.isSelected = !self.btnTCAgree.isSelected
            if self.btnTCAgree.isSelected && self.enteredOtp.count == 6{
                self.btnVerifyOTP.enableButton()
            }else{
                self.btnVerifyOTP.disbledButton()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.otpView.initializeUI()
    }
    func tapToReSendOTP()
    {
        countdownTimer.invalidate()
        totalTime = 60
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    @objc func updateTime() {
        if totalTime != 0 {
            self.btnReSendOtp.setTitle("\(timeFormatted(totalTime))", for: .normal)
            totalTime -= 1
        } else {
            self.btnReSendOtp.setTitle("Resend OTP", for: .normal)
            endTimer()
        }
    }
    func endTimer() {
        countdownTimer.invalidate()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        endTimer()
    }
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        return String(format: "%02d sec",seconds)
    }
    func lblTermAndConditionAttribute() {
        self.lblTermAndCondition.text = "By entering OTP you agree to accept our Terms & Condition and Privacy Policy"
        let boldText1 = "Terms & Condition"
        let boldText2 = "Privacy Policy"
        let normalText = "By entering OTP you agree to accept our "
        let normalText1 = " and "
        
        let normalAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.loraFont(size: 13, weight: .Regular),
            .foregroundColor: UIColor.black
        ]
        let normalString = NSMutableAttributedString(string: normalText, attributes: normalAttrs)
        
        let boldAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.loraFont(size: 13, weight: .Regular),
            .foregroundColor: UIColor(named: "appBlue") ?? .blue
        ]
        
        let attributedString1 = NSMutableAttributedString(string: boldText1, attributes: boldAttrs)
        let attributedString2 = NSMutableAttributedString(string: boldText2, attributes: boldAttrs)
        
        normalString.append(attributedString1)
        normalString.append(NSMutableAttributedString(string: normalText1, attributes: normalAttrs))
        normalString.append(attributedString2)
        
        lblTermAndCondition.attributedText = normalString
        lblTermAndCondition.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTermConditionTap(_:)))
        lblTermAndCondition.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTermConditionTap(_ gesture: UITapGestureRecognizer) {
        guard let text = lblTermAndCondition.text else { return }
        let termsRange = (text as NSString).range(of: "Terms & Condition")
        let privacyRange = (text as NSString).range(of: "Privacy Policy")
        
        let tapLocation = gesture.location(in: lblTermAndCondition)
        let textStorage = NSTextStorage(attributedString: lblTermAndCondition.attributedText!)
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: lblTermAndCondition.bounds.size)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = lblTermAndCondition.numberOfLines
        textContainer.lineBreakMode = lblTermAndCondition.lineBreakMode
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        let locationOfTouchInLabel = tapLocation
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(
            x: (lblTermAndCondition.bounds.size.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
            y: (lblTermAndCondition.bounds.size.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y
        )
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        if NSLocationInRange(indexOfCharacter, termsRange) {
            // Open Terms of Use link
            if let url = URL(string: "https://www.google.com") {
                UIApplication.shared.open(url)
            }
        } else if NSLocationInRange(indexOfCharacter, privacyRange) {
            // Open Privacy Policy link
            if let url = URL(string: "https://www.google.com") {
                UIApplication.shared.open(url)
            }
        }
    }
    
}
extension SecurityCodeViewController: VPMOTPViewDelegate {
    func hasEnteredAllOTP(hasEntered: Bool) -> Bool {
        return true
    }
    
    func shouldBecomeFirstResponderForOTP(otpFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otpString: String) {
        enteredOtp = otpString
        if self.btnTCAgree.isSelected && self.enteredOtp.count == 6{
            self.btnVerifyOTP.enableButton()
        }else{
            self.btnVerifyOTP.disbledButton()
        }
        print("OTPString: \(otpString)")
    }
}
// MARK: API Call
extension SecurityCodeViewController {
    
    private func sendOTP_APICall() {
        print("number :- ",self.userModel?.contactNumber)
        print("hashtoken :- ",self.userModel?.hashToken)
        let params = [APIParameters.Login.contactNumber: (self.userModel?.contactNumber ?? mobile),
                      APIParameters.Login.telephoneCodes: (self.userModel?.telephoneCodes ?? countryID)
        ] as [String : Any]
        CustomLoader.shared.showLoader(on: self.view)
        WebServiceManager.sharedInstance.callAPI(apiPath: .sendOtpUserLogin, method: .post, params: params,isAuthenticate: false, model: CommonRespons<LoginUserModel>.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async { [weak self] in
                    if data.statusCode == 200{
                        self?.userModel = data.data
                        self?.tapToReSendOTP()
                    }else{
                        self?.view.makeToast(data.message ?? "")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async { 
                    self.view.makeToast(error.localizedDescription)
                }
            }
        }
    }
    private func verifyOTP_APICall() {
        print("Verity hashtoken :- ",self.userModel?.hashToken)
        let params = [APIParameters.Login.contactNumber: mobile,
                      APIParameters.Login.otp: self.enteredOtp,
                      APIParameters.hashToken: (self.userModel?.hashToken ?? ""),
                      APIParameters.Login.countryCode: countryID
                ]
        CustomLoader.shared.showLoader(on: self.view)
        WebServiceManager.sharedInstance.callAPI(apiPath: .verifyOtp, method: .post, params: params,isAuthenticate: false, model: CommonRespons1<[LoginUserModel],[AgencyModel]>.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {
                    if data.statusCode == 200 {
                        UserDetails.shared.loginModel = data.data?.first
                        if self.isForget {
                            let vc = Storyboard.Login.instantiateViewController(withViewClass: SetYourPinVC.self)
                            vc.otp = self.enteredOtp
                            self.navigationController?.pushViewController(vc, animated: true)
                        }else{
                            if (data.dbList?.count ?? 0) > 1{
                                let vc = Storyboard.Login.instantiateViewController(withViewClass: SelectDBViewController.self)
                                vc.list = data.dbList ?? []
                                self.navigationController?.pushViewController(vc, animated: true)
                            }else{
                                if let t = data.dbList?.first{
                                    self.SelectDB_APICall(model:t)
                                }
                            }
                        }
                        
                        
                    }else{
                        self.otpView.initializeUI()
                        self.enteredOtp = ""
                        self.view.makeToast(data.message ?? "")
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
                DispatchQueue.main.async { [weak self] in
                    if data.statusCode == 200{
                        self?.userModel = data.data
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
    private func SelectDB_APICall(model:AgencyModel) {
        let params = ["contact_number":model.contact_number ?? "","user_id":model.id ?? 0,"agency_id":model.agency_id ?? ""] as [String : Any]
        CustomLoader.shared.showLoader(on: self.view)
        WebServiceManager.sharedInstance.callAPI(apiPath: .selectdbname, method: .post, params: params,isAuthenticate: true, model: CommonRespons<[LoginUserModel]>.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async { [weak self] in
                    if data.statusCode == 200 {
                        UserDetails.shared.loginModel = data.data?.first
                        if (UserDetails.shared.loginModel?.passcode ?? "") == "" {
                            let vc = Storyboard.Login.instantiateViewController(withViewClass: SetYourPinVC.self)
                            self?.navigationController?.pushViewController(vc, animated: true)
                        }else{
                            let vc = Storyboard.Login.instantiateViewController(withViewClass: EnterYourPinVC.self)
                            self?.navigationController?.pushViewController(vc, animated: true)
                        }
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

