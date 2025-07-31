//
//  UIApplication+Extension.swift
//  BaseProject
//
//  Created by Gauravkumar Gudaliya on 2/1/17.
//  Copyright © 2017 GauravkumarGudaliya. All rights reserved.


import UIKit

extension UIStoryboard {
    public static var mainStoryboard: UIStoryboard? {
        let bundle = Bundle.main
        guard let name = bundle.object(forInfoDictionaryKey: "UIMainStoryboardFile") as? String else {
            return nil
        }
        return UIStoryboard(name: name, bundle: bundle)
    }
    
    static var Main: UIStoryboard {
        if let main = mainStoryboard {
            return main
        }
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    func instantiateViewController<T: UIViewController>(withViewClass: T.Type) -> T {
        return instantiateViewController(withIdentifier: String(describing: withViewClass.self)) as! T
    }
    
    class func instantiateViewController<T: UIViewController>(withViewClass: T.Type) -> T {
        return UIStoryboard.Main.instantiateViewController(withIdentifier: String(describing: withViewClass.self)) as! T
    }
}

extension UIViewController {
    func pushViewController(_ viewController: UIViewController.Type, animated: Bool){
        let vc = UIStoryboard.instantiateViewController(withViewClass: viewController)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}
enum Storyboard: String {
    case Main
    case Login
    case Visits
    case Clients
    case Alerts
  
    private var storyboard: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: nil)
    }
    
    func instantiateViewController<T: UIViewController>(withViewClass: T.Type) -> T {
        return storyboard.instantiateViewController(withIdentifier: String(describing: withViewClass.self)) as! T
    }
}
