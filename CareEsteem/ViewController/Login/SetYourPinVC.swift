//
//  SetYourPinVC.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 07/03/25.
//


import UIKit
import PinCodeInputView


class SetYourPinVC: UIViewController {

    @IBOutlet weak var vwTextField: UIView!
    var otp = ""
    let pinCodeInputView: PinCodeInputView<PasswordItemView> = .init(
        digit: 4,
        itemSpacing: 15,
        itemFactory: {
            return PasswordItemView()
        })
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { [weak self] in
            self?.setUpUI()
        })
    }

    private func setUpUI() {
        
        vwTextField.addSubview(pinCodeInputView)
    
        pinCodeInputView.frame = vwTextField.bounds
        pinCodeInputView.isUserInteractionEnabled = false
        
        pinCodeInputView.set(changeTextHandler: { text in
        
            if text.count > 3 {
                let vc = Storyboard.Login.instantiateViewController(withViewClass: ConfirmPinVC.self)
                vc.setPin = text
                vc.otp = self.otp
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
        
        pinCodeInputView.set(
            appearance: .init(
                itemSize: CGSize(width: 12, height: 12),
                font: .systemFont(ofSize: 28, weight: .bold),
                textColor: UIColor(named: "appGreen") ?? .green,
                backgroundColor: UIColor.blue.withAlphaComponent(0.3),
                cursorColor: UIColor(named: "appGreen") ?? .green,
                cornerRadius: 8
            )
        )
        let keyboard = CustomKeyboardView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-32, height: self.view.frame.width-32))
        keyboard.keyPressed = { pin in
            if pin == "⌫"{
                self.pinCodeInputView.deleteBackward()
            }else{
                self.pinCodeInputView.insertText(pin)
            }
        }
        view.addSubview(keyboard)
        keyboard.translatesAutoresizingMaskIntoConstraints = false
        
        let ff = self.view.viewWithTag(8)
        NSLayoutConstraint.activate([
            keyboard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            keyboard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            keyboard.topAnchor.constraint(equalTo: ff!.bottomAnchor, constant: 50),
        ])
    }
    
    @objc func didBecameActive() {
        if let string = UIPasteboard.general.string {
            pinCodeInputView.set(text: string)
        }
    }
    
    @objc func tap() {
        pinCodeInputView.resignFirstResponder()
    }
    
}

final class PasswordItemView: UIView, ItemType {
    
    var text: Character? = nil {
        didSet {
            guard let _ = text else {
                backgroundColor = .clear
                return
            }
            backgroundColor = appearance?.textColor
        }
    }
    
    var isHiddenCursor: Bool = false
    private var appearance: ItemAppearance?
    
    init() {
        
        super.init(frame: .zero)
        
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let appearance = appearance else { return }
        let length = min(appearance.itemSize.width, appearance.itemSize.height)
        frame = CGRect(x: 0, y: 0, width: length, height: length)
        layer.cornerRadius = length / 2
    }
    
    func set(appearance: ItemAppearance) {
        self.appearance = appearance
        
        bounds.size = appearance.itemSize
        layer.borderColor = appearance.textColor.cgColor
        layer.borderWidth = 1
        
        layoutIfNeeded()
    }
    
}
