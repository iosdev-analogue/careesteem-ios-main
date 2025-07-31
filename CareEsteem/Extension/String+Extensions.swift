//
//  String+Extensions.swift
//  Alfayda
//
//  Created by Wholly-iOS on 22/08/18.
//  Copyright © 2018 Whollysoftware. All rights reserved.
//

import UIKit

extension String {
    public var isNull: Bool    {
        return self.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty
    }
    
    public var isNotNull: Bool    {
        return !self.isNull
    }
    
    func or(_ defaultValue: String) -> String {
        return self.isNull ? defaultValue : self
    }
    
    var isValidEmail: Bool {
        if (self.isNull) { return false }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    var isEmptyString : Bool {
        return self.isEmpty || self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || self == "N/A"
    }
    func maskPhoneNumber() -> String {
        guard self.count >= 6 else { return self } // Ensure valid length
        
        let prefix = self.prefix(0)    // Keep first 2 digits
        let suffix = self.suffix(3)    // Keep last 3 digits
        let masked = String(repeating: "*", count: self.count - 7)
        
        return prefix + masked + suffix
    }
    func fixBase64Padding(_ base64: String) -> String {
        return base64.replacingOccurrences(of: "data:image/png;base64,", with: "").replacingOccurrences(of: "data:image/jpeg;base64,", with: "").replacingOccurrences(of: "data:image/jpg;base64,", with: "")
    }
    func base64ToUIImage() -> UIImage? {
        if self.isEmpty{
            return UIImage(named: "logo")
        }else{
            guard let imageData = Data(base64Encoded: fixBase64Padding(self), options: .ignoreUnknownCharacters) else { return UIImage(named: "logo") }
            return UIImage(data: imageData)
        }
    }
    func addSpaceBeforeUppercase() -> String {
        let pattern = "([a-z])([A-Z])"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: self.utf16.count)
        
        return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "$1 $2")
    }

}
func convertStringToDate(dateString: String, format: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    dateFormatter.timeZone = .current//TimeZone(identifier: "Europe/London")
    return dateFormatter.date(from: dateString)
}

func convertDateToString(date: Date, format: String,timeZone:TimeZone? = .current) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    dateFormatter.timeZone = .current
    return dateFormatter.string(from: date)
}
extension Dictionary where Value == CodableValue {
    func toAnyObject() -> [Key: AnyObject] {
        var result: [Key: AnyObject] = [:]
        for (key, codableValue) in self {
            result[key] = codableValue.value as AnyObject
        }
        return result
    }
}
