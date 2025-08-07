//
//  InfoHstackTableViewCell.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 09/03/25.
//


import UIKit
class InfoHstackTableViewCell:UITableViewCell{
    
    @IBOutlet weak var stack: UIStackView!
    
    func setupData(model:RiskAssesstment){
        
        if !model.isBottom{
            for (index,item) in model.value.enumerated() {
                if model.isListItem{
                    if index == 0{
                        let titleLabel = UILabel()
                        titleLabel.text = item.title
                        titleLabel.textAlignment = .center
                        titleLabel.numberOfLines = 0
                        titleLabel.font = UIFont.robotoSlab(.regular, size: 13)
                        //RobotoSlabFont(size: 13, weight: .Regular)
                        titleLabel.textColor = .black
                        stack.addArrangedSubview(titleLabel)
                    }else{
                        let rowStack = createRow(title: item.title, value: item.value)
                        stack.addArrangedSubview(rowStack)
                    }
                }else{
                    let rowStack = createRow(title: item.title, value: item.value)
                    stack.addArrangedSubview(rowStack)
                }
            }
        }
        if model.isBottom{
            let titleLabel = UILabel()
            titleLabel.text = "Signatures of All Involved Admins in the Assessment"
            titleLabel.numberOfLines = 0
            titleLabel.font = UIFont.loraFont(size: 13, weight: .Regular)
            titleLabel.textColor = .black
            stack.addArrangedSubview(titleLabel)
            stack.addArrangedSubview(self.createNameAndDate(model: model))
        }
    }
    func createRow(title: String, value: String) -> UIStackView {
        let rowStack = UIStackView()
        rowStack.axis = .horizontal
        rowStack.spacing = 10
        rowStack.alignment = .fill
        rowStack.distribution = .fill
        rowStack.isLayoutMarginsRelativeArrangement = true
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.loraFont(size: 13, weight: .Regular)
        titleLabel.textColor = .black
        titleLabel.widthAnchor.constraint(equalToConstant: self.frame.width/2.2).isActive = true
        
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
        rowStack.addArrangedSubview(titleLabel)
        rowStack.addArrangedSubview(dotLabel)
        rowStack.addArrangedSubview(valueLabel)
        
        return rowStack
    }
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
    
    func createSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return separator
    }
}
