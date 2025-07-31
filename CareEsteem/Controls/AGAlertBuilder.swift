//
//  AGAlertController.swift
//  BaseProject
//
//  Created by GauravkumarGudaliya on 14/02/18.
//  Copyright © 2018 GauravkumarGudaliya. All rights reserved.
//

import UIKit

class AGAlertBuilder: UIAlertController {

    typealias AGAlertActionBlock = ((UIAlertAction) -> Swift.Void)
    
    var isVisible : Bool {
        return self.view.superview != nil
    }
    
    enum TapOnType {
        case outSide
        case none
        case autoHidden(time: TimeInterval)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(withAlert title: String?, message: String?) {
        self.init(title: title, message: message, preferredStyle: .alert)
    }
 
    convenience init(withActionSheet title: String?, message: String?, iPadOpen: ActionSheetOpen, directions: UIPopoverArrowDirection = .any) {
        self.init(title: title, message: message, preferredStyle: .actionSheet)
        self.setPopoverPresentationProperties(iPadOpen, directions: directions)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: UIAlertAction Methods
    @discardableResult
    func defaultAction(with title: String?, handler: AGAlertActionBlock? = nil) -> Self{
        let action = UIAlertAction(title: title, style: .default, handler: handler)
        addAction(action)
        return self
    }
    
    @discardableResult
    func cancelAction(with title: String?, handler: AGAlertActionBlock? = nil) -> Self{
        let action = UIAlertAction(title: title, style: .cancel, handler: handler)
        addAction(action)
        return self
    }
    
    @discardableResult
    func destructiveAction(with title: String?, handler: AGAlertActionBlock? = nil) -> Self{
        let action = UIAlertAction(title: title, style: .destructive, handler: handler)
        addAction(action)
        return self
    }
    
    @discardableResult
    func addAction(with title: String?, style: UIAlertAction.Style, handler: AGAlertActionBlock? = nil) -> Self{
        let action = UIAlertAction(title: title, style: style, handler: handler)
        addAction(action)
        return self
    }
    
    @discardableResult
    public func show(delayTime: TimeInterval? = nil, animated: Bool = true, completion: (() -> Void)? = nil) -> Self{
        
        //If a delay time has been set, delay the presentation of the alert by the delayTime
        if let time = delayTime {
            let dispatchTime = DispatchTime.now() + time
            DispatchQueue.main.asyncAfter(deadline: dispatchTime) {[weak self] in
                AppDelegate.shared.topViewController()?.present(self!, animated: animated, completion: completion)
            }
        }
        else{
            DispatchQueue.main.async {
                AppDelegate.shared.topViewController()?.present(self, animated: animated, completion: completion)
            }
        }
        
        return self
    }
    
    func dissmiss(withType withHandler: @escaping (() -> Void), dismissType: TapOnType = .none) {
        switch dismissType {
            
        case .outSide:
            self.view.superview?.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(alertControllerBackgroundTapped))
            tap.numberOfTapsRequired = 1
            self.view.superview?.addGestureRecognizer(tap)
            break
            
        case .none: break
            
        case .autoHidden(time: let time):
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {[weak self] in
                if self!.isVisible{
                    self?.dismiss(animated: true, completion: nil)
                    withHandler()
                }
            }
            break
        }
    }
    
    enum ActionSheetOpen{
        case sourceView(UIView)
        case sourceRect(CGRect)
        case barButtonItem(UIBarButtonItem)
    }
    
    @discardableResult
    public func setPopoverPresentationProperties( _ iPadOpen: ActionSheetOpen, directions: UIPopoverArrowDirection = .any) -> Self {
        
        if let poc = self.popoverPresentationController {
            switch iPadOpen {
            case .sourceView(let view):
                poc.sourceView = view
                
            case .sourceRect(let rect):
                poc.sourceRect = rect
                
            case .barButtonItem(let item):
                poc.barButtonItem = item
            }
            
            poc.permittedArrowDirections = directions
        }
        
        return self
    }
    
    @objc func alertControllerBackgroundTapped(){
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: Image added in alert and Action Sheet
extension AGAlertBuilder {
    @discardableResult
    func addImage(with image: UIImage, width: CGFloat, height: CGFloat) -> Self{
        
        let displayImage = UIImageView(image: image)
        self.view.addSubview(displayImage)
        displayImage.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(NSLayoutConstraint(item: displayImage, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: displayImage, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: displayImage, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: width))
        self.view.addConstraint(NSLayoutConstraint(item: displayImage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height))
        return self
    }
}

extension AGAlertBuilder {
    enum AttributeType: String{
        case attributedTitle
        case attributedMessage
    }
    
    func setAttributedTitle(type: AttributeType, attribute: [NSAttributedString.Key: Any]){
        let titleAttrString = NSMutableAttributedString(string: title ?? "", attributes: attribute)
        self.setValue(titleAttrString, forKey: type.rawValue)
    }
}
