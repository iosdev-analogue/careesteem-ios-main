//
//  AGView.swift
//  BaseProject
//
//  Created by Wholly-iOS on 22/08/18.
//  Copyright © 2018 GauravkumarGudaliya. All rights reserved.
//

import UIKit
@IBDesignable
class AGView: UIView {
    
    @IBInspectable
    public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
            layer.masksToBounds = false
        }
    }
    
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
    
    @IBInspectable var isCircle : Bool = false {
        didSet{ layoutSubviews() }
    }
    @IBInspectable var isClipsCircle : Bool = false {
           didSet{ layoutSubviews() }
       }
    @IBInspectable var isTopCorner : Bool = false {
           didSet{ layoutSubviews() }
       }
    @IBInspectable var isLeftCorner : Bool = false {
           didSet{ layoutSubviews() }
       }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isCircle {
            self.cornerRadius = self.layer.frame.size.height / 2
            layer.masksToBounds = true
        }else if isClipsCircle{
            clipsToBounds = true
        }else if isTopCorner{
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            clipsToBounds = true
        }else if isLeftCorner{
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            clipsToBounds = true
        }
    }
}
