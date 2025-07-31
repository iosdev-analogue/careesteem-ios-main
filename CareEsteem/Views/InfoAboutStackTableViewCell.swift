//
//  InfoAboutStackTableViewCell.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 09/03/25.
//



import UIKit
class InfoAboutStackTableViewCell:UITableViewCell{
    
    @IBOutlet weak var stack: UIStackView!
    
    func setupData(riskModel:[RiskAssesstment], title: String? = nil){
        let theSubviews : [UIView] = stack.subviews
        for view in theSubviews {
            view.removeFromSuperview()
        }
        
        if let title = title {
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.numberOfLines = 0
            titleLabel.font = UIFont.loraFont(size: 15, weight: .Bold)
            titleLabel.textColor = .black
            titleLabel.textAlignment = .center
            titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
            titleLabel.widthAnchor.constraint(equalToConstant: self.frame.width - 20).isActive = true
            stack.addArrangedSubview(titleLabel)
        }
        
        for model in riskModel {
            setupDataRisk(model: model)
        }
        
        let separator = createbottomSeparator()
        stack.addArrangedSubview(separator)
        stack.layer.borderColor = UIColor(named: "appGreen")?.cgColor
        stack.layer.borderWidth = 1
        stack.layer.cornerRadius = 10
        stack.clipsToBounds = true
        
    }
    
    func setupData(model:[MyPopupListModel], border: Bool? = false, title: String? = nil) {
        let theSubviews : [UIView] = stack.subviews
        for view in theSubviews {
            view.removeFromSuperview()
        }
        if let title = title {
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.numberOfLines = 0
            titleLabel.font = UIFont.loraFont(size: 15, weight: .Bold)
            titleLabel.textColor = .black
            titleLabel.textAlignment = .center
            titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
            titleLabel.widthAnchor.constraint(equalToConstant: self.frame.width - 20).isActive = true
            stack.addArrangedSubview(titleLabel)
        }
        for (index,item) in model.enumerated() {
            let rowStack = createRow(title: item.title, value: item.value)
            stack.addArrangedSubview(rowStack)
            
            if index < model.count - 1 {
                let separator = createSeparator()
                stack.addArrangedSubview(separator)
            }
        }
        
        if border ?? false {
            let separator = createbottomSeparator()
            stack.addArrangedSubview(separator)
            stack.layer.borderColor = UIColor(named: "appGreen")?.cgColor
            stack.layer.borderWidth = 1
            stack.layer.cornerRadius = 10
            stack.clipsToBounds = true
//            addTopBorderWithColor(stack, color: .red, width: 1)
//            addLeftBorderWithColor(stack, color: .red, width: 1)
//            addRightBorderWithColor(stack, color: .red, width: 1)
//            addBottomBorderWithColor(stack, color: .red, width: 1)
        }
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
        space.font = UIFont.loraFont(size: 20, weight: .Regular)
        space.textColor = .black
        space.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.loraFont(size: 13, weight: .Regular)
        titleLabel.textColor = .black
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
   
    func createbottomSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = .white
        separator.heightAnchor.constraint(equalToConstant: 5).isActive = true
        return separator
    }
    
}

extension InfoAboutStackTableViewCell {
    func setupDataRisk(model:RiskAssesstment){
        let stack1 = UIStackView()
        stack1.axis = .vertical
        stack1.spacing = 10
        stack1.alignment = .fill
        stack1.distribution = .fill
        stack1.isLayoutMarginsRelativeArrangement = true
        if !model.isBottom{
            for (index,item) in model.value.enumerated() {
                if model.isListItem{
                    if index == 0{
                        let titleLabel = UILabel()
                        titleLabel.text = item.title
                        titleLabel.textAlignment = .center
                        titleLabel.numberOfLines = 0
                        titleLabel.font = UIFont.loraFont(size: 13, weight: .Regular)
                        titleLabel.textColor = .black
                        stack1.addArrangedSubview(titleLabel)
                    }else{
                        let rowStack = createRow(title: item.title, value: item.value)
                        stack1.addArrangedSubview(rowStack)
                    }
                }else{
                    let rowStack = createRow(title: item.title, value: item.value)
                    stack1.addArrangedSubview(rowStack)
                }
            }
            
        }
        if model.isBottom{
            let vStack = UIStackView()
            vStack.axis = .vertical
            vStack.spacing = 10
            vStack.alignment = .fill
            vStack.distribution = .fill
            vStack.isLayoutMarginsRelativeArrangement = true
            
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
            space.font = UIFont.loraFont(size: 20, weight: .Regular)
            space.textColor = .black
            space.widthAnchor.constraint(equalToConstant: 10).isActive = true
            
            let titleLabel = UILabel()
            titleLabel.text = "Signatures of All Involved Admins in the Assessment"
            titleLabel.numberOfLines = 0
            titleLabel.font = UIFont.loraFont(size: 13, weight: .Regular)
            titleLabel.textColor = .black
            vStack.addArrangedSubview(titleLabel)
            vStack.addArrangedSubview(self.createNameAndDate(model: model))
            rowStack.addArrangedSubview(space)
            rowStack.addArrangedSubview(vStack)
            stack1.addArrangedSubview(rowStack)
        }
        stack.addArrangedSubview(stack1)

    }
//    func createRow1(title: String, value: String) -> UIStackView {
//        let rowStack = UIStackView()
//        rowStack.axis = .horizontal
//        rowStack.spacing = 10
//        rowStack.alignment = .fill
//        rowStack.distribution = .fill
//        rowStack.isLayoutMarginsRelativeArrangement = true
//        
//        let titleLabel = UILabel()
//        titleLabel.text = title
//        titleLabel.numberOfLines = 0
//        titleLabel.font = UIFont.loraFont(size: 13, weight: .Regular)
//        titleLabel.textColor = .black
//        titleLabel.widthAnchor.constraint(equalToConstant: self.frame.width/2.2).isActive = true
//        
//        let dotLabel = UILabel()
//        dotLabel.text = ":"
//        dotLabel.textAlignment = .center
//        dotLabel.numberOfLines = 0
//        dotLabel.font = UIFont.loraFont(size: 20, weight: .Regular)
//        dotLabel.textColor = .black
//        dotLabel.widthAnchor.constraint(equalToConstant: 10).isActive = true
//        
//        let valueLabel = UILabel()
//        valueLabel.text = value
//        valueLabel.font = UIFont.loraFont(size: 13, weight: .Regular)
//        valueLabel.textColor = .black
//        valueLabel.numberOfLines = 0
//        rowStack.addArrangedSubview(titleLabel)
//        rowStack.addArrangedSubview(dotLabel)
//        rowStack.addArrangedSubview(valueLabel)
//        
//        return rowStack
//    }
    func createNameAndDate(model:RiskAssesstment) -> UIStackView {
        let rowStack = UIStackView()
        rowStack.axis = .horizontal
        rowStack.spacing = 10
        rowStack.alignment = .leading
        rowStack.distribution = .equalSpacing
        rowStack.isLayoutMarginsRelativeArrangement = true
        
        let data: [(title: String, value: String)] = [
            ("Name", model.name),
            ("Date", model.date)
            ]
        for (index, item) in data.enumerated() {
            let colStack1 = UIStackView()
            colStack1.axis = .vertical
            colStack1.spacing = 5
            colStack1.alignment = .top
            colStack1.distribution = .fill
            colStack1.isLayoutMarginsRelativeArrangement = true
            
            let titleLabel = UILabel()
            titleLabel.text = item.title
            titleLabel.numberOfLines = 0
            titleLabel.font = UIFont.loraFont(size: 13, weight: .Regular)
            titleLabel.textColor = .black
            titleLabel.widthAnchor.constraint(equalToConstant: self.frame.width/2.2).isActive = true
            
            let valueLabel = UILabel()
            valueLabel.text = item.value
            valueLabel.font = UIFont.loraFont(size: 13, weight: .Regular)
            valueLabel.textColor = .black
            valueLabel.numberOfLines = 0
            colStack1.addArrangedSubview(titleLabel)
            colStack1.addArrangedSubview(valueLabel)
            rowStack.addArrangedSubview(colStack1)
        }
        
        return rowStack
    }
    
}
