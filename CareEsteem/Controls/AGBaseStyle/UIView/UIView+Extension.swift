//
//  UIView+Extension.swift
//  BaseProject
//
//  Created by Gauravkumar Gudaliya on 24/06/18.
//  Copyright © 2018 GauravkumarGudaliya. All rights reserved.
//

import UIKit
import ObjectiveC

extension UIView {
    
    /// Load view from nib. Note: Nib name must be equal to the class name.
    ///
    /// - parameter view:    The name of the nib file, which need not include the .nib extension
    /// - parameter owner:   The object to assign as the nib’s File's Owner object
    /// - parameter options: options
    ///
    /// - returns: view
    class func loadFromNibAndClass<T : UIView>(_ view: T.Type, owner: Any? = nil, options: [AnyHashable : Any]? = nil) -> T? {
        
        let name = String(describing: view.self)
        
        guard let nib = Bundle.main.loadNibNamed(name, owner: owner, options: options as? [UINib.OptionsKey : Any]) else { return nil }
        
        return nib.first as? T
    }
    
    class func loadFromNib(named name: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(nibName: name, bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
}

extension UIView {
    
    var nsHeightConstraint: NSLayoutConstraint? {
        get {
            return constraints.filter {
                if $0.firstAttribute == .height, $0.relation == .equal {
                    return true
                }
                return false
                }.first
        }
        set{ setNeedsLayout() }
    }
    
    var nsWidthConstraint: NSLayoutConstraint? {
        get {
            return constraints.filter {
                if $0.firstAttribute == .width, $0.relation == .equal {
                    return true
                }
                return false
                }.first
        }
        set{ setNeedsLayout() }
    }
    
    @objc var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    public var screenshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, 0.0);
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

//MARK : My Custom
extension UIView{
    
    func renderImage() -> UIImage {
        
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(size: (self.bounds.size))
            return  renderer.image { ctx in
                self.layer.render(in: ctx.cgContext)
            }
        } else {
            return UIImage()
        }
    }
    
    public func addSubviews(_ subviews: [UIView]) {
        subviews.forEach({self.addSubview($0)})
    }
    func setupHexagonView() {
        let lineWidth: CGFloat = 0
        let path = self.roundedPolygonPath(rect: self.frame, lineWidth: lineWidth, sides: 6, cornerRadius: 5, rotationOffset: CGFloat(.pi / 2.0))
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        mask.lineWidth = lineWidth
        mask.strokeColor = UIColor.black.cgColor
        mask.fillColor = UIColor.white.cgColor
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 20
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 0.5
        self.layer.mask = mask
        
        let border = CAShapeLayer()
        border.path = path.cgPath
        border.lineWidth = lineWidth
        border.strokeColor = UIColor.white.cgColor
        border.fillColor = UIColor.clear.cgColor
       // self.layer.addSublayer(border)
    }
    public func roundedPolygonPath(rect: CGRect, lineWidth: CGFloat, sides: NSInteger, cornerRadius: CGFloat, rotationOffset: CGFloat = 0) -> UIBezierPath {
        let path = UIBezierPath()
        let theta: CGFloat = CGFloat(2.0 * .pi) / CGFloat(sides) // How much to turn at every corner
        let width = min(rect.size.width, rect.size.height)        // Width of the square
        
        let center = CGPoint(x: rect.origin.x + width / 2.0, y: rect.origin.y + width / 2.0)
        
        // Radius of the circle that encircles the polygon
        // Notice that the radius is adjusted for the corners, that way the largest outer
        // dimension of the resulting shape is always exactly the width - linewidth
        let radius = (width - lineWidth + cornerRadius - (cos(theta) * cornerRadius)) / 2.0
        
        // Start drawing at a point, which by default is at the right hand edge
        // but can be offset
        var angle = CGFloat(rotationOffset)
        
        let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle), y: center.y + (radius - cornerRadius) * sin(angle))
        path.move(to: CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta)))
        
        for _ in 0..<sides {
            angle += theta
            
            let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle), y: center.y + (radius - cornerRadius) * sin(angle))
            let tip = CGPoint(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
            let start = CGPoint(x: corner.x + cornerRadius * cos(angle - theta), y: corner.y + cornerRadius * sin(angle - theta))
            let end = CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta))
            
            path.addLine(to: start)
            path.addQuadCurve(to: end, controlPoint: tip)
        }
        
        path.close()
        
        // Move the path to the correct origins
        let bounds = path.bounds
        let transform = CGAffineTransform(translationX: -bounds.origin.x + rect.origin.x + lineWidth / 2.0, y: -bounds.origin.y + rect.origin.y + lineWidth / 2.0)
        path.apply(transform)
        
        return path
    }
}

public extension UIView {
    
    public func shake(duration: TimeInterval = 1, completion:(() -> Void)? = nil) {
        
        CATransaction.begin()
        let animation: CAKeyframeAnimation
        animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        
        CATransaction.setCompletionBlock(completion)
        animation.duration = duration
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
        CATransaction.commit()
    }
}
class HexagonView:UIView{
    override func layoutSubviews() {
        super.layoutSubviews()
        setupHexagonView()
    }
}
