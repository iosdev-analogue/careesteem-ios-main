import UIKit
class NetworkManager {
    static let shared = NetworkManager()
    
    private let reachability = try! Reachability()
    
    var alert = UIAlertController()
    func startNetworkMonitoring() {
        reachability.whenReachable = { reachability in
            self.alert.dismiss(animated: false)
            if reachability.connection == .wifi {
                DebugLogs.shared.printLog("Connected via WiFi")
            } else if reachability.connection == .cellular {
                DebugLogs.shared.printLog("Connected via Cellular")
            }
        }
        
        reachability.whenUnreachable = { _ in
            DebugLogs.shared.printLog("No Internet Connection")
            self.alert = UIAlertController(title: "No Internet Connection", message: "Connect to the internet and try again.", preferredStyle: .alert)
           // self.alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            AppDelegate.shared.topViewController()?.present(self.alert, animated: true, completion: nil)
        }
        do {
            try reachability.startNotifier()
        } catch {
            DebugLogs.shared.printLog("Unable to start notifier")
        }
    }
    
    func stopNetworkMonitoring() {
        reachability.stopNotifier()
    }
    
    func isConnectedToInternet() -> Bool {
        return reachability.connection != .unavailable
    }
}
