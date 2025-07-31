import UIKit

class CustomKeyboardView: UIView {
    
    // Callback to send the pressed key back to the parent view
    var keyPressed: ((String) -> Void)?
    
    // Buttons layout
    private var buttons: [[String]] = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        ["", "0", "⌫"]
    ]
    
    private let buttons1: [[String]] = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        ["☑", "0", "⌫"]
    ]
    var faceID: Bool = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        faceID = universalFaceID
        buttons = faceID ? buttons1 : buttons
        setupButtons()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    private func setupButtons() {
        
        let spacing = UIScreen.main.bounds.width / 10
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = spacing/2
        stackView.alignment = .center
        
        for row in buttons {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.spacing = spacing
           
            for title in row {
                let button = createButton(with: title)
                rowStackView.addArrangedSubview(button)
            }
            stackView.addArrangedSubview(rowStackView)
        }
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func createButton(with title: String) -> UIButton {
        let button = AGButton()
        let buttonSize = UIScreen.main.bounds.width / 6
        button.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        button.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        if title.isNotNull{
                button.setTitle(title, for: .normal)
            if title == "☑" && faceID {
                let button = UIButton()
                let buttonSize = UIScreen.main.bounds.width / 6
                button.setTitle(title, for: .normal)
                button.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
                button.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
//                button.setBackgroundImage(UIImage(named: "faceID"), for: .normal)
                button.setImage(UIImage(named: "faceID"), for: .normal)
                button.backgroundColor = .clear
                button.setTitleColor(UIColor(named: "appGreen") ?? .green, for: .normal)
                button.layer.cornerRadius = buttonSize / 2
                button.clipsToBounds = true
                button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
                return button

            }else if title == "⌫"{
                button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
                button.backgroundColor = .clear
                button.setTitleColor(UIColor(named: "appGreen") ?? .green, for: .normal)
            }else{
                button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
                button.backgroundColor = UIColor(named: "keypadBG") ?? .green
                button.setTitleColor(.black, for: .normal)
            }
            button.isCircle = true
            button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
        return button
    }
    
    @objc private func buttonPressed(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }
        keyPressed?(title)  // Notify parent view
    }
}
