//
//  ImageTextField.swift
//  BaseProject
//
//  Created by Gauravkumar Gudaliya on 31/01/19.
//  Copyright © 2017 GauravkumarGudaliya. All rights reserved.
//

import UIKit

enum ValidationType {
    case none
    case email
    case password
    case number
    case charaterLimit(Int)
    case numberLimit(Int)
    case string
}

class AGTextField: UITextField, UITextFieldDelegate {
    
    @IBInspectable
    public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
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
    
    var validationType: ValidationType = .none {
        didSet{
            switch self.validationType {
            case .email:
                self.keyboardType = .emailAddress
                break
            case .number, .numberLimit(_):
                self.keyboardType = .phonePad
                break
            case .password:
                self.isSecureTextEntry = true
                self.keyboardType = .default
                break
            case .none:
                self.keyboardType = .default
                break
            default:
                self.keyboardType = .default
                break
            }
        }
    }
    
    var paddingInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 10)
    
    @IBInspectable var padding: CGFloat = 0
    
    @IBInspectable var leftImage: UIImage? {
        didSet{
            setLeftImageView()
        }
    }
    @IBInspectable var rightImage: UIImage? {
        didSet{
            setRightImageView()
        }
    }
    
    @IBInspectable var iconColor: UIColor = UIColor.darkGray
    
    @IBInspectable override var placeholder: String? {
        didSet {
            reloadPlaceHolderColor()
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var placeholderTextColor: UIColor? {
        didSet {
            reloadPlaceHolderColor()
            self.setValue(placeholderTextColor, forKeyPath: "_placeholderLabel.textColor")
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var isCircle: Bool = false {
        didSet {
            layoutSubviews()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        if delegate == nil  {
            delegate = self
        }
        
        autocapitalizationType = .sentences
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if delegate == nil  {
            delegate = self
        }
        autocapitalizationType = .sentences
    }
    
    // Provides left padding for image
    internal override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += padding
        paddingInsets.left = textRect.origin.x + textRect.width  + padding
        return textRect
    }
    
    // Provides right padding for image
    internal override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x -= padding
        paddingInsets.right =  textRect.width + padding
        return textRect
    }
    
    internal override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: paddingInsets)
    }
    
    internal override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: paddingInsets)
    }
    
    internal override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: paddingInsets)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isCircle {
            self.cornerRadius = self.layer.frame.size.height / 2
        }
        reloadPlaceHolderColor()
    }
    
    fileprivate func reloadPlaceHolderColor() {
//        if let color = self.placeholderTextColor ?? self.textColor {
//            attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [.foregroundColor: color])
//        }
    }
    
    func setRightImageView(){
        if let image = rightImage {
            rightViewMode = UITextField.ViewMode.always
            
            let imageView = UIImageView(frame: CGRect.zero)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalToConstant: self.frame.height/2)
            imageView.heightAnchor.constraint(equalToConstant: self.frame.height/2)
            
            imageView.image = image
            imageView.tintColor = iconColor
            rightView = imageView
            
            switch self.validationType {
            case .password:
                imageView.isUserInteractionEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(showHiddenPasswordAction(_:)))
                tap.numberOfTapsRequired = 1
                imageView.addGestureRecognizer(tap)
                break
            default: break
            }
            
        } else {
            rightViewMode = UITextField.ViewMode.never
            rightView = nil
        }
    }
    
    func setLeftImageView() {
        if let image = leftImage {
            leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect.zero)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalToConstant: self.frame.height/2)
            imageView.heightAnchor.constraint(equalToConstant: self.frame.height/2)
            imageView.image = image
            imageView.tintColor = iconColor
            leftView = imageView
        } else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }
    }
    
    @objc func showHiddenPasswordAction(_ sender: UIButton){
        let tempText = self.text
        isSecureTextEntry = !isSecureTextEntry
        self.text = tempText
    }
    
    // MARK: - UITextField Delegate Methods -
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /**
     TextField delegate method for check the max character limit.
     */
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch validationType {
        case .number:
            if string.rangeOfCharacter(from: NSCharacterSet.decimalDigits.inverted) == nil{
                return true
            }
            return false
            
        case .numberLimit(let limit):
            if string.rangeOfCharacter(from: NSCharacterSet.decimalDigits.inverted) == nil{
                let oldlength : Int = textField.text?.count ?? 0
                let newLength : Int = oldlength - range.length + string.count
                return newLength <= limit || false
            }
            return false
            
        case .charaterLimit(let limit):
            let oldlength : Int = textField.text?.count ?? 0
            let newLength : Int = oldlength - range.length + string.count
            return newLength <= limit || false
            
        case .string:
            if string.rangeOfCharacter(from: NSCharacterSet.decimalDigits.inverted) != nil{
                return true
            }
            return false
            
        default:
            return true
        }
    }
}


extension UITextView {
    public var isNull: Bool    {
        if let t = self.text {
            return t.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty
        }
        return false
    }
}
