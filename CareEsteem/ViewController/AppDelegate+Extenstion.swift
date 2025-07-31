

import UIKit
import UserNotifications
import Firebase
import FirebaseMessaging

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        debugPrint(userInfo)
        self.notification = response.notification
        self.checkPushNotification()
        completionHandler()
    }
    
    func checkPushNotification(){
        if let responsenotification = AppDelegate.shared.notification,UserDetails.shared.loginModel != nil,AppDelegate.shared.isAppLoaded{
            AppDelegate.shared.notification = nil
            let userInfo = responsenotification.request.content.userInfo
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: userInfo, options: .prettyPrinted)
                let decoder = JSONDecoder()
                let object = try decoder.decode(GCMNotificationModel.self, from: jsonData)
                if object.notificationType == "1"{
                  
                }else if object.notificationType == "2"{
                  
                }
                debugPrint(object)
            } catch let error {
                debugPrint(error.localizedDescription)
            }
//            debugPrint(userInfo)
        }
    }
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        completionHandler([.sound,.banner,.list])
    }
    //MARK:- Register for push notification.
    func registerForRemoteNotifications(application: UIApplication) {
        debugPrint("Registering for Push Notification...")
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions, completionHandler: { (granted, error) in
                if error == nil{
                    DispatchQueue.main.async(execute: {
                        application.registerForRemoteNotifications()
                    })
                } else {
                    debugPrint("Error Occurred while registering for push \(String(describing: error?.localizedDescription))")
                }
        })
        application.registerForRemoteNotifications()
    }
    
    func application(application: UIApplication,
                             didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        Messaging.messaging().apnsToken = deviceToken
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let token = fcmToken{
            UserDetails.shared.fcm_id = token
        }
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {
        completionHandler(UIBackgroundFetchResult.newData)
    }
    func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([UIUserActivityRestoring]?
        ) -> Void) -> Bool {
        
        // 1
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let url = userActivity.webpageURL,
              let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                  
            return false
        }
        deeplink = userActivity.webpageURL?.absoluteString
        self.CheckDeeplink()
        return false
    }
    func application(_ application: UIApplication,
                     open url: URL,
                     sourceApplication: String?,
                     annotation: Any) -> Bool{
        
        if url.host == nil
        {
            return false;
        }
        
        deeplink = url.absoluteString
        self.CheckDeeplink()
        return true
    }
    func CheckDeeplink(){
        if let link = AppDelegate.shared.deeplink,UserDetails.shared.loginModel != nil,AppDelegate.shared.isAppLoaded{
            deeplink = nil
            
        }
    }
}
