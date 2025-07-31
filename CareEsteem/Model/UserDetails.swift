//
//  UserDetails.swift
//  Alfayda
//
//  Created by Wholly-iOS on 25/08/18.
//  Copyright © 2018 Whollysoftware. All rights reserved.
//

import UIKit
import AVFoundation


class UserDetails: NSObject {
    
    static var isNewInstallled: Bool {
        get { return UserDefaults.standard.bool(forKey: "isNewInstallled") }
        set { UserDefaults.standard.set(newValue, forKey: "isNewInstallled") }
    }
    static var shared = UserDetails()
    static var appVersionAndBulid: String {
        return UserDefaults.standard.string(forKey: "appVersion") ?? ""
    }
    
    var user_id: String {
        return (UserDetails.shared.loginModel?.id ?? "").description
    }
    
    var device_id:String{
        get{
            return UniquiUdid.App.UDID
        }
        set{
            
        }
    }
    var fcm_id: String {
        get { return UserDefaults.standard.string(forKey: "fcm_id") ?? device_id }
        set { UserDefaults.standard.set(newValue, forKey: "fcm_id") }
    }
    override init() {
        super.init()
    }
    
    func clear() {
        if let domain = Bundle.main.bundleIdentifier {
         
            let fcm = UserDetails.shared.fcm_id
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
            print("Clear ValuesCount :- \(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)")
            UserDetails.shared.fcm_id = fcm
        }
    }
    var authToken: String {
        get { return UserDefaults.standard.string(forKey: "authToken") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "authToken") }
    }
    var loginModel:LoginUserModel? {
        get{
            if let modelData = UserDefaults.standard.object(forKey: "loginModel") as? Data {
                let decoder = JSONDecoder()
                if let model = try? decoder.decode(LoginUserModel.self, from: modelData) {
                    return model
                }
            }
            return nil
        }
        set{
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: "loginModel")
            }
        }
    }
    var profileModel:ProfileModel? {
        get{
            if let modelData = UserDefaults.standard.object(forKey: "profileModel") as? Data {
                let decoder = JSONDecoder()
                if let model = try? decoder.decode(ProfileModel.self, from: modelData) {
                    return model
                }
            }
            return nil
        }
        set{
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: "profileModel")
            }
        }
    }
}


class Application: NSObject {
    
    /// EZSE: Returns app's version number
    public static var appVersion: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }
    
    /// EZSE: Return app's build number
    public static var appBuild: String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String ?? ""
    }
}
