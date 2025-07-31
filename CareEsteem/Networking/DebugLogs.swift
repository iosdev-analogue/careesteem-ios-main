
import ObjectiveC
import UIKit

class DebugLogs:NSObject {
    static var shared:DebugLogs = DebugLogs()
     func printLog(_ items: Any..., separator: String = " ", terminator: String = "\n") {
         #if DEBUG
         debugPrint(items,separator:separator,terminator: terminator)
        #endif
    }
}
