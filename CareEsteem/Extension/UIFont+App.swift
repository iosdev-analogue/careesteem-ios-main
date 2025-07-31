//
//  UIFont+Extension.swift
//  Agent310
//
//  Created by Gauravkumar Gudaliya on 14/06/18.
//  Copyright © 2018 WhollySoftware. All rights reserved.
//

import UIKit

import UIKit

public enum RobotoSlab: String {
    case Bold
    case BoldItalic
    case Italic
    case Regular
}
public enum OpenSans: String {
    case Regular
    case Medium
    case Light
    case Italic
    case Bold
    case SemiBold
}
public enum Lora: String {
    case Regular
    case Bold
}

public extension UIFont {
    
    class func RobotoSlabFont(size: CGFloat, weight: RobotoSlab) -> UIFont {
        if let font = UIFont(name: "RobotoSlab-\(weight)", size: size) {
            return font
        }
        else{
            fatalError("Font not found RobotoSlab-\(weight)")
        }
    }
    
    class func openSansFont(size: CGFloat, weight: OpenSans) -> UIFont {
        if let font = UIFont(name: "OpenSans-\(weight)", size: size) {
            return font
        }
        else{
            fatalError("Font not found OpenSans-\(weight)")
        }
    }
    class func loraFont(size: CGFloat, weight: Lora) -> UIFont {
        if let font = UIFont(name: "Lora-\(weight)", size: size) {
            return font
        }
        else{
            fatalError("Font not found Lora-\(weight)")
        }
    }
}
