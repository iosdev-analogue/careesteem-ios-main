//
//  SplashScreenController.swift
//  careesteem
//
//  Created by Gaurav Gudaliya on 07/03/25.
//
import UIKit
class SplashScreenController: UIViewController{

    @IBOutlet weak var imgSplash:UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black;
        UIView.animate(withDuration: 0.3) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
//        
//#if DEBUG
//                AppDelegate.shared.SetTabBarMainView()
//                return
//#endif
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) { 
            if UserDetails.shared.loginModel != nil {
                if (UserDetails.shared.loginModel?.passcode ?? "") != "" {
                    let vc = Storyboard.Login.instantiateViewController(withViewClass: EnterYourPinVC.self)
                    let navi = CustomNavigationController(rootViewController: vc)
                    navi.isNavigationBarHidden = true
                    AppDelegate.shared.window?.rootViewController = navi
                }else{
                    let vc = Storyboard.Login.instantiateViewController(withViewClass: SetYourPinVC.self)
                    let navi = CustomNavigationController(rootViewController: vc)
                    navi.isNavigationBarHidden = true
                    AppDelegate.shared.window?.rootViewController = navi
                }
            }else{
                let vc = Storyboard.Login.instantiateViewController(withViewClass: LoginViewController.self)
                let navi = CustomNavigationController(rootViewController: vc)
                navi.isNavigationBarHidden = true
                AppDelegate.shared.window?.rootViewController = navi
            }
        }
    }
}
