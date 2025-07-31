
import UIKit

private class AssociatedKeyHolder {}
private let associatedKey = AssociatedKeyHolder()
extension UIScrollView {
    private class ActionWrapper {
        let action: RefreshControlAction
        init(action: @escaping RefreshControlAction) {
            
            self.action = action
        }
    }
    
    typealias RefreshControlAction = ((UIRefreshControl) -> Void)
    
    var pullToRefreshScroll: (RefreshControlAction)? {
        set(newValue) {
            agRefreshControl.tintColor = UIColor(named: "appGreen") ?? .green
            agRefreshControl.removeTarget(self, action: #selector(refreshAction1(_:)), for: .valueChanged)
            var wrapper: ActionWrapper? = nil
            if let newValue = newValue {
                wrapper = ActionWrapper(action: newValue)
                agRefreshControl.addTarget(self, action: #selector(refreshAction1(_:)), for: .valueChanged)
            }
            objc_setAssociatedObject(self, Unmanaged.passUnretained(associatedKey).toOpaque(), wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            guard let wrapper = objc_getAssociatedObject(self, Unmanaged.passUnretained(associatedKey).toOpaque()) as? ActionWrapper else {
                return nil
            }
            
            return wrapper.action
        }
    }
    
    var agRefreshControl: UIRefreshControl {
        if #available(iOS 10.0, *) {
            if let refreshView = self.refreshControl {
                return refreshView
            }
            else{
                self.refreshControl = UIRefreshControl()
                return self.refreshControl!
            }
        }
        else{
            return UIRefreshControl()
        }
    }
    func endRefreshing() {
        agRefreshControl.endRefreshing()
    }

    func beginRefreshing() {
        agRefreshControl.beginRefreshing()
    }
    
    @objc private func refreshAction1(_ refreshControl: UIRefreshControl) {
        if let action = pullToRefreshScroll {
            action(refreshControl)
        }
    }
}
extension UIScrollView {
    func scrollToBottom(animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            if self.contentSize.height < self.bounds.size.height { return }
            let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
            self.setContentOffset(bottomOffset, animated: animated)            
        }
    }
}
