//
//  AppDelegate.swift
//  careesteem
//
//  Created by Gaurav Gudaliya on 07/03/25.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
import UserNotifications
import GoogleMaps
import GooglePlaces


var googleAPIKey = "AIzaSyDVUeAtCLN1dvo711iPCgTL1dLHiV5Z1Ec"
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,MessagingDelegate{

    var window: UIWindow?
    var notification : UNNotification?
    var isAppLoaded = false
    var deeplink:String?
    
    static var shared: AppDelegate {
           return UIApplication.shared.delegate as! AppDelegate
       }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.keyboardConfiguration.overrideAppearance = true
        WebServiceManager.sharedInstance.startNetworkingCheck()
        FirebaseApp.configure()
        self.registerForRemoteNotifications(application: application)
        Messaging.messaging().delegate = self
        GMSServices.provideAPIKey(googleAPIKey)
        GMSPlacesClient.provideAPIKey(googleAPIKey)
        return true
    }
    func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        debugPrint(base as Any)
        return base
    }
    
    func logOut() {
        UserDetails.shared.loginModel = nil
        UserDefaults.standard.removeObject(forKey: "loginModel")
        let vc = Storyboard.Login.instantiateViewController(withViewClass: LoginViewController.self)
        let navi = CustomNavigationController(rootViewController: vc)
        navi.isNavigationBarHidden = true
        window?.rootViewController = navi
    }
    
    func SetTabBarMainView(){
        let vc = Storyboard.Main.instantiateViewController(withViewClass: MainTabViewController.self)
        let nav = UINavigationController(rootViewController: vc)
    //    let nav = UINavigationController(rootViewController: UITabBarController())
        nav.isNavigationBarHidden = true
        window?.rootViewController = nav
    }
    func openSettingForApp(){
        if let appUrl = URL(string: UIApplication.openSettingsURLString) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appUrl)
            } else {
                UIApplication.shared.openURL(appUrl)
            }
        }
    }
}

