//
//  UIPlaceHolderTextView.swift
//  BaseProject
//
//  Created by Gauravkumar Gudaliya on 31/01/19.
//  Copyright © 2017 GauravkumarGudaliya. All rights reserved.
//

import UIKit

class AGTextView: UITextView {
    
    @IBInspectable var placeholderColor : UIColor = UIColor(white: 0.7, alpha: 1.0)
    @IBInspectable var placeholder : String? = nil
    
    @IBInspectable
    public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
            layer.masksToBounds = true
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
    
    override var font : UIFont? {
        willSet(font) {
            super.font = font
        }
        didSet(font) {
            setNeedsDisplay()
        }
    }
    
    override var contentInset : UIEdgeInsets {
        willSet(text) {
            super.contentInset = contentInset
        }
        didSet(text) {
            setNeedsDisplay()
        }
    }
    
    override var textAlignment : NSTextAlignment {
        willSet(textAlignment) {
            super.textAlignment = textAlignment
        }
        didSet(textAlignment) {
            setNeedsDisplay()
        }
    }
    
    override var text : String? {
        willSet(text) {
            super.text = text
        }
        didSet(text) {
            setNeedsDisplay()
        }
    }
    
    override var attributedText: NSAttributedString! {
        willSet(attributedText) {
            super.attributedText = attributedText
        }
        didSet(text) {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    convenience init(placeholder: String) {
        self.init()
        self.placeholder = placeholder
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged(_:)), name: UITextView.textDidChangeNotification, object: self)
        contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        if (text! == "" && placeholder != nil) {
            let paragraphStyle = NSMutableParagraphStyle()
            let attributes: [NSAttributedString.Key : Any] = [
                .font : font ?? UIFont.robotoSlab(.regular, size: 15),
                //RobotoSlabFont(size: 15, weight: .Regular)
                .foregroundColor : placeholderColor,
                .paragraphStyle : paragraphStyle]

            placeholder?.draw(in: placeholderRectForBounds(bounds: bounds), withAttributes: attributes)
            contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        }
        super.draw(rect)
    }

    @objc private func textChanged(_ notification: NSNotification) {
        setNeedsDisplay()
    }
    
    private func placeholderRectForBounds(bounds : CGRect) -> CGRect {

        let left = contentInset.left
        let right = contentInset.right
        let top = contentInset.top
        let bottom = contentInset.bottom

        var x = left
        var y = top
        let w = frame.size.width - left - right
        let h = frame.size.height - top - bottom

        if let style = self.typingAttributes[.paragraphStyle] as? NSParagraphStyle {
            x += style.headIndent
            y += style.firstLineHeadIndent
        }

        return CGRect(x: x, y: y, width: w, height: h)
    }
}
