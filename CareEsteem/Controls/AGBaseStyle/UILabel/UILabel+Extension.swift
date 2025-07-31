//
//  UILabel+Extension.swift
//  BaseProject
//
//  Created by Wholly-iOS on 22/08/18.
//  Copyright © 2018 GauravkumarGudaliya. All rights reserved.
//

import UIKit

extension UILabel {
    
    var isTruncated: Bool {
        
        guard let labelText = text else {
            return false
        }
        
        let labelTextSize = (labelText as NSString).boundingRect(
            with: CGSize(width: frame.size.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil).size
        
        return labelTextSize.height > bounds.size.height
    }
}


extension UILabel {
    
    func height(_ text:String,font:CGFloat, width:CGFloat) {
        self.frame =  CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: width, height: CGFloat.greatestFiniteMagnitude)
        self.numberOfLines = 0
        self.lineBreakMode = .byWordWrapping
        self.font = UIFont.systemFont(ofSize: font)
        self.text = text
        self.sizeToFit()
    }
}
