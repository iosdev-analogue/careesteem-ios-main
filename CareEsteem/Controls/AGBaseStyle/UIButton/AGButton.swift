//
//  AGButton.swift
//  BaseProject
//
//  Created by Gauravkumar Gudaliya on 31/01/19.
//  Copyright © 2017 GauravkumarGudaliya. All rights reserved.
//

import UIKit

open class AGButton: UIButton {
    
    @IBInspectable
    public var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.masksToBounds = false
            layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
        }
    }
    
    @IBInspectable
    public var borderColor: UIColor? {
        get {
            return  layer.borderColor == nil ? nil : UIColor(cgColor: layer.borderColor!)
        }
        set { layer.borderColor = newValue?.cgColor }
    }
    
    @IBInspectable
    public var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable
    public var shadowColor: UIColor? {
        get {
            return  layer.shadowColor == nil ? nil : UIColor(cgColor: layer.shadowColor!)
        }
        set { layer.shadowColor = newValue?.cgColor }
    }
    
    @IBInspectable
    public var shadowOffset: CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }
    
    @IBInspectable
    public var shadowOpacity: Float {
        get { return layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }
    
    @IBInspectable
    public var shadowRadius: CGFloat {
        get { return layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }

    typealias ButtonAction = () -> Void
    
    @IBInspectable var isCircle : Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.defaultInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.defaultInit()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        if isCircle {
            self.cornerRadius = self.layer.frame.size.height / 2
            layer.masksToBounds = true
        }
    }
    
    private struct AssociatedKeys {
        static var ActionKey = "ActionKey"
    }
    
    private class ActionWrapper {
        let action: ButtonAction
        init(action: @escaping ButtonAction) {
            self.action = action
        }
    }
    
    var action: ButtonAction? {
        set(newValue) {
            if action != nil {
                fatalError("Action method is already assigned. Must be remove old action")
            }
            removeTarget(self, action: #selector(performAction), for: .touchUpInside)
            var wrapper: ActionWrapper? = nil
            if let newValue = newValue {
                wrapper = ActionWrapper(action: newValue)
                addTarget(self, action: #selector(performAction), for: .touchUpInside)
            }
            objc_setAssociatedObject(self, &AssociatedKeys.ActionKey, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            guard let wrapper = objc_getAssociatedObject(self, &AssociatedKeys.ActionKey) as? ActionWrapper else {
                return nil
            }
            
            return wrapper.action
        }
    }
    
    private func defaultInit() {
    
    }
    
    @objc private func performAction() {
        
        if let vc = self.parentViewController {
            vc.view.endEditing(true)
        }

        guard let action = action else {
            return
        }

        action()
    }
}
extension UIButton{
    
    func enableButton(){
        self.isEnabled = true
        self.backgroundColor = UIColor(named: "appGreen")
    }
    func disbledButton(){
        self.isEnabled = false
        self.backgroundColor = UIColor(named: "appOffGray")
    }
}

extension UIView {
    public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
}

