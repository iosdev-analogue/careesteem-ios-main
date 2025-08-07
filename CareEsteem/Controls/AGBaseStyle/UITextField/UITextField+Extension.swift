//
//  UITextField+Extension.swift
//  BaseProject
//
//  Created by Wholly-iOS on 22/08/18.
//  Copyright © 2018 GauravkumarGudaliya. All rights reserved.
//

import UIKit

extension UITextField {
    
    public var isNull: Bool    {
        if let t = self.text {
            return t.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty
        }
        return false
    }
    
    public var isValidEmail: Bool {
        if (text == nil || (text?.isEmpty)!) { return false }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self.text)
    }
    
    public var isValidPhone: Bool {
        if (text == nil || (text?.isEmpty)!) { return false }
        
        let emailRegEx = "^[0-9]{10,14}$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self.text)
    }
    
    /*
     1. 8 characters length
     2. alphabet
     3. special character
     */
    
    func isPasswordValid() -> Bool{
        if (text == nil || (text?.isEmpty)!) { return false }
        let passwordRegEx = "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}"
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: self.text)
    }
}

