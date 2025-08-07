//
//  UniquiUdid.swift
//  BaseProject
//
//  Created by Wholly-iOS on 12/09/18.
//  Copyright © 2018 AshvinGudaliya. All rights reserved.
//

import UIKit

class UniquiUdid: NSObject {
    
    struct App {
        static var UDID: String {

            if let udidData = UniquiUdid.loadUDID(), !udidData.toString().isEmpty {
                let udid = udidData.toString()
                return udid
            }
        
            let genrateUdid = UniquiUdid.UDID
            if let data = genrateUdid.data(using: String.Encoding.utf8) {
                UniquiUdid.save(data: data)
            }
            return genrateUdid
        }
    }
    
    static var UDID: String {
        return UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
    }

    @discardableResult
    class func save(data: Data) -> OSStatus {
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : "loginTimeUDID",
            kSecValueData as String   : data ] as [String : Any]
        
        SecItemDelete(query as CFDictionary)
        
        return SecItemAdd(query as CFDictionary, nil)
    }
    
    @discardableResult
    class func loadUDID() -> Data? {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : "loginTimeUDID",
            kSecReturnData as String  : kCFBooleanTrue ?? false,
            kSecMatchLimit as String  : kSecMatchLimitOne ] as [String : Any]
        
        var dataTypeRef: AnyObject? = nil
        
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == noErr {
            return dataTypeRef as! Data?
        } else {
            return nil
        }
    }
}

extension Data {

    func toString() -> String {
        return String.init(data: self, encoding: String.Encoding.utf8) ?? ""
    }
}

