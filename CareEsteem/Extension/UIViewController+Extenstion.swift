//
//  UIViewController+Extenstion.swift
//  EyeNak
//
//  Created by Gaurav Gudaliya on 13/04/22.
//  Copyright © 2022 Gaurav Gudaliya R. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController{
    func setupBlackTintColor(){
        // self.navigationBar.barStyle = .black
        self.isNavigationBarHidden = true
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = UIColor.clear
            appearance.shadowColor = UIColor.clear

            navigationBar.standardAppearance = appearance;
            navigationBar.scrollEdgeAppearance = appearance;
            navigationBar.compactAppearance = appearance;

            navigationBar.tintColor =  UIColor(named: "appGreen") ?? UIColor.black
            navigationBar.shadowImage = UIImage()
            navigationBar.backIndicatorImage = UIImage(named: "back")
            navigationBar.backIndicatorTransitionMaskImage =  UIImage(named: "back")
            navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
            
        } else {
            let backImage = UIImage(named: "back")
            self.navigationBar.backIndicatorImage = backImage
            self.navigationBar.backIndicatorTransitionMaskImage = backImage
            
            self.navigationBar.tintColor = UIColor(named: "appGreen") ?? UIColor.black
            self.navigationBar.barTintColor = UIColor.clear
            self.navigationBar.isTranslucent = false
            self.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationBar.shadowImage = UIImage()
            self.navigationBar.barStyle = UIBarStyle.default;
            
        }
    }
}
extension UIImage {
    convenience init(color: UIColor, size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        color.set()
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.fill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        self.init(data: image.pngData()!)!
    }
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        newSize = CGSize(width: targetSize.width,  height: targetSize.height)
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}
