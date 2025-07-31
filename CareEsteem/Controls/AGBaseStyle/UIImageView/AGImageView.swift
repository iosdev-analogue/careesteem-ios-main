//
//  AGImageView.swift
//  BaseProject
//
//  Created by Wholly-iOS on 22/08/18.
//  Copyright © 2018 GauravkumarGudaliya. All rights reserved.
//

import UIKit

class AGImageView: UIImageView {
    
    @IBInspectable
    public var borderColor: UIColor? {
        get {
            return  layer.borderColor == nil ? nil : UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    public var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    public var shadowColor: UIColor? {
        get {
            return  layer.shadowColor == nil ? nil : UIColor(cgColor: layer.shadowColor!)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    public var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    public var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    public var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.masksToBounds = true
            layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
        }
    }
    
    @IBInspectable var isCircle : Bool = false {
        didSet{ layoutSubviews() }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isCircle {
            cornerRadius = self.layer.frame.size.height / 2
            layer.masksToBounds = true
        }
    }
}

class EditProfileView: AGView {
    
    var shape: CAShapeLayer?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if shape == nil {
            shape = CAShapeLayer()
            layer.addSublayer(shape!)
        }
        
        shape?.opacity = 1
        shape?.lineWidth = 2
        shape?.lineJoin = CAShapeLayerLineJoin.miter
        shape?.strokeColor = (self.backgroundColor ?? .white).cgColor
        shape?.fillColor = (self.backgroundColor ?? .white).cgColor
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: self.frame.height))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height * 0.75))
        path.addQuadCurve(to: CGPoint(x: 0, y: self.frame.height * 0.75), controlPoint: CGPoint(x: self.frame.width / 2, y: self.frame.height + (self.frame.height * 0.2)))
        path.close()
        shape?.path = path.cgPath
    }
}
