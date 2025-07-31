import UIKit

class CenterPresentationController: UIPresentationController {
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView?.frame = UIScreen.main.bounds
    }
    
    @objc private func dismissController() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}

class CenterTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CenterPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CenterPresentAnimation()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CenterDismissAnimation()
    }
}

class CenterPresentAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else { return }
        let containerView = transitionContext.containerView
        
        // Step 1: Create and configure the dimming background view
        let dimmingView = UIView(frame: containerView.bounds)
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0) // Start fully transparent
        containerView.addSubview(dimmingView) // Add dimming view first
        
        // Step 2: Set initial state for modal view
        toView.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
        toView.alpha = 0
        containerView.addSubview(toView) // Add modal view on top
        
        // Step 3: Animate both the modal and background
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5) // Fade in background
            toView.alpha = 1
            toView.transform = .identity
        }) { finished in
            transitionContext.completeTransition(finished)
        }
    }
}

class CenterDismissAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5  // Match the present transition time
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        let containerView = transitionContext.containerView
        
        // Find the dimming view
        let dimmingView = containerView.subviews.first { $0 is UIView && $0.backgroundColor?.cgColor.alpha ?? 0 > 0 }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            fromView.alpha = 0
            fromView.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
            dimmingView?.backgroundColor = UIColor.black.withAlphaComponent(0) // Fade out background
        }) { finished in
            dimmingView?.removeFromSuperview() // Remove dimming view
            fromView.removeFromSuperview()
            transitionContext.completeTransition(finished)
        }
    }
}
