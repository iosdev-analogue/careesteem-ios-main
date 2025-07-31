//
//  PlaceholderTextView.swift
//


import UIKit

open class PlaceholderTextView: UITextView {

    fileprivate let placeholderLabel: UILabel = UILabel()
    
    fileprivate var placeholderLabelConstraints = [NSLayoutConstraint]()
    
    fileprivate var heightConstraint: NSLayoutConstraint!
    fileprivate var minHeightConstraint: NSLayoutConstraint!
    fileprivate var maxHeightConstraint: NSLayoutConstraint!
    
    @IBInspectable open var placeholder: String = "" {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    
    @IBInspectable open var placeholderColor: UIColor = UIColor.gray {
        didSet {
            placeholderLabel.textColor = placeholderColor
        }
    }
    
    override open var font: UIFont! {
        didSet {
            placeholderLabel.font = font
        }
    }
    
    override open var textAlignment: NSTextAlignment {
        didSet {
            placeholderLabel.textAlignment = textAlignment
        }
    }
    
    override open var text: String! {
        didSet {
            textDidChange()
        }
    }
    
    override open var attributedText: NSAttributedString! {
        didSet {
            textDidChange()
        }
    }
    
    override open var textContainerInset: UIEdgeInsets {
        didSet {
            updateConstraintsForPlaceholderLabel()
        }
    }
    
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
        self.associateConstraints()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        self.associateConstraints()
    }
    
    fileprivate func commonInit() {
        NotificationCenter.default.addObserver(self,
            selector: #selector(PlaceholderTextView.textDidChange),
            name: UITextView.textDidChangeNotification,
            object: nil)
        
        placeholderLabel.font = font
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.textAlignment = textAlignment
        placeholderLabel.text = placeholder
        placeholderLabel.numberOfLines = 0
        placeholderLabel.backgroundColor = UIColor.clear
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeholderLabel)
        updateConstraintsForPlaceholderLabel()
    }
    
    fileprivate func updateConstraintsForPlaceholderLabel() {
        var newConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(\(textContainerInset.left + textContainer.lineFragmentPadding))-[placeholder]-(\(textContainerInset.right + textContainer.lineFragmentPadding))-|",
            options: [],
            metrics: nil,
            views: ["placeholder": placeholderLabel])
        
        newConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(\(textContainerInset.top))-[placeholder]",
            options: [],
            metrics: nil,
            views: ["placeholder": placeholderLabel])
        
        removeConstraints(placeholderLabelConstraints)
        addConstraints(newConstraints)
        placeholderLabelConstraints = newConstraints
    }
    
    @objc fileprivate func textDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
        self.layoutSubviews()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        self.setNeedsDisplay()
        
        // Placeholder text color
        self.font = UIFont.RobotoSlabFont(size: 15, weight: .Regular)
        
        if self.heightConstraint != nil && maxHeightConstraint != nil{
        
            let sizeThatFits: CGSize = self.sizeThatFits(frame.size)
            var newHeight = Float(sizeThatFits.height)
            
            if (maxHeightConstraint != nil) {
                newHeight = min(newHeight, Float(maxHeightConstraint.constant))
            }
            
            if (minHeightConstraint != nil) {
                newHeight = max(newHeight, Float(minHeightConstraint.constant))
            }
            
            self.heightConstraint.constant = CGFloat(newHeight)
        
        }
    }
    
    func associateConstraints() {
        // iterate through all text view's constraints and identify
        // height, max height and min height constraints.
        //        self.isScrollEnabled = true
        for constraint: NSLayoutConstraint in constraints {
            if constraint.firstAttribute == .height {
                if constraint.relation == .equal {
                    heightConstraint = constraint
                }
                else if constraint.relation == .lessThanOrEqual {
                    maxHeightConstraint = constraint
                }
                else if constraint.relation == .greaterThanOrEqual {
                    minHeightConstraint = constraint
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: UITextView.textDidChangeNotification,
            object: nil)
    }
}
