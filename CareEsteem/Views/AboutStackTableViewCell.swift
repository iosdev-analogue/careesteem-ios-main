//
//  AboutStackTableViewCell.swift
//  CareEsteem
//
//  Created by Nitin Chauhan on 23/06/25.
//

import UIKit

class AboutStackTableViewCell: UITableViewCell {

    @IBOutlet weak var view: AGView!
    @IBOutlet weak var stack: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupData(model:[MyPopupListModel], border: Bool? = false, imageUrl: String?) {
        let theSubviews : [UIView] = stack.subviews
        for view in theSubviews {
            view.removeFromSuperview()
        }
        
        if let imageUrl = imageUrl {
            let rowStack = UIStackView()
            rowStack.axis = .vertical
            rowStack.spacing = 10
            rowStack.alignment = .center
            rowStack.distribution = .fill
            rowStack.isLayoutMarginsRelativeArrangement = true
            rowStack.addArrangedSubview(getVerticalspace(hight: 15))

            let iv:AGImageView = AGImageView()
            iv.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "logo1"))
            iv.clipsToBounds = true
            iv.isCircle = true
            iv.heightAnchor.constraint(equalToConstant: 90).isActive = true
            iv.widthAnchor.constraint(equalToConstant: 90).isActive = true
            rowStack.addArrangedSubview(iv)
            stack.addArrangedSubview(rowStack)
        }
        
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.alignment = .center
        for (index,item) in model.enumerated() {
            if index < 3 {
                let rowStack = createCol(title: item.title, value: item.value)
                hStack.addArrangedSubview(rowStack)
                if index == 2 {
                    stack.addArrangedSubview(hStack)
                    stack.addArrangedSubview(getVerticalspace(hight: 5))
                }
            } else {
                let rowStack = createRow(title: item.title, value: item.value)
                stack.addArrangedSubview(rowStack)
            }
        }
        view.shadowOffset = CGSize(width: 0, height: -2)
        view.shadowRadius = 5
        view.shadowColor = UIColor.black
        view.shadowOpacity = 0.80
//        stack.superview?.addShadow(cornerRadius: 0, color: .red, offset: .zero, opacity: 0.8, shadowRadius: 0)
    }
    
    func getVerticalspace(hight: Int) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.text = ""
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.loraFont(size: 15, weight: .Bold)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.heightAnchor.constraint(equalToConstant: CGFloat(hight)).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: self.frame.width - 20).isActive = true
        return titleLabel
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func createbottomSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = .white
        separator.heightAnchor.constraint(equalToConstant: 5).isActive = true
        return separator
    }
    
    func createCol(title: String, value: String) -> UIStackView {
        let rowStack = UIStackView()
        rowStack.axis = .vertical
        rowStack.spacing = 0
        rowStack.alignment = .center
        rowStack.distribution = .fill
        rowStack.isLayoutMarginsRelativeArrangement = true

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.loraFont(size: 13, weight: .Regular)
        titleLabel.textColor = .gray
        titleLabel.textAlignment = .center
        titleLabel.widthAnchor.constraint(equalToConstant: self.frame.width/3).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let valueLabel = UILabel()
        valueLabel.text = value.count > 0 ? value : "NA"
        valueLabel.font = UIFont.loraFont(size: 13, weight: .Bold)
        valueLabel.textColor = UIColor(named: "appGreen")
        valueLabel.clipsToBounds = true
        valueLabel.textAlignment = .center
        valueLabel.widthAnchor.constraint(equalToConstant: self.frame.width/4).isActive = true
        valueLabel.numberOfLines = 0
        valueLabel.layer.borderColor = UIColor(named: "appGreen")?.cgColor
        valueLabel.layer.borderWidth = 1
        valueLabel.layer.cornerRadius = 15
        valueLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true

        rowStack.addArrangedSubview(titleLabel)
        rowStack.addArrangedSubview(valueLabel)
        
        return rowStack
    }

    
    func createRow(title: String, value: String) -> UIStackView {
        let rowStack = UIStackView()
        rowStack.axis = .horizontal
        rowStack.spacing = 10
        rowStack.alignment = .fill
        rowStack.distribution = .fill
        rowStack.isLayoutMarginsRelativeArrangement = true
        
        let space = UILabel()
        space.text = " "
        space.textAlignment = .center
        space.numberOfLines = 0
        space.font = UIFont.loraFont(size: 20, weight: .Bold)
        space.textColor = UIColor(named: "appGreen")
        space.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.loraFont(size: 13, weight: .Regular)
        titleLabel.textColor = UIColor(named: "appGreen")
        titleLabel.widthAnchor.constraint(equalToConstant: self.frame.width/2).isActive = true
        
        let dotLabel = UILabel()
        dotLabel.text = ":"
        dotLabel.textAlignment = .center
        dotLabel.numberOfLines = 0
        dotLabel.font = UIFont.loraFont(size: 20, weight: .Regular)
        dotLabel.textColor = .black
        dotLabel.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.loraFont(size: 13, weight: .Regular)
        valueLabel.textColor = .black
        valueLabel.numberOfLines = 0
        rowStack.addArrangedSubview(space)
        rowStack.addArrangedSubview(titleLabel)
        rowStack.addArrangedSubview(dotLabel)
        rowStack.addArrangedSubview(valueLabel)
        
        return rowStack
    }

    func createSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = UIColor(named: "appGreen")!.withAlphaComponent(0.3)
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return separator
    }
}

extension UIView {

    func generateOuterShadow() {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = layer.cornerRadius
        view.layer.shadowRadius = layer.shadowRadius
        view.layer.shadowOpacity = 0.5
        view.layer.shadowColor = layer.shadowColor
        view.layer.shadowOffset = CGSize.zero
        view.clipsToBounds = false
        view.backgroundColor = .red

        superview?.insertSubview(view, belowSubview: self)

        let constraints = [
            NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0),
        ]
        superview?.addConstraints(constraints)
    }
    
    func addShadow(cornerRadius: CGFloat, color: UIColor, offset: CGSize, opacity: Float, shadowRadius: CGFloat) {
            self.layer.cornerRadius = cornerRadius
//            self.layer.maskedCorners = maskedCorners
            self.layer.shadowColor = color.cgColor
            self.layer.shadowOffset = offset
            self.layer.shadowOpacity = opacity
            self.layer.shadowRadius = shadowRadius
        }
}
