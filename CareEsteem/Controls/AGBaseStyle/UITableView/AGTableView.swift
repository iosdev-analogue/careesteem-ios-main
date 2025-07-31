//
//  AGTableView.swift
//  BaseProject
//
//  Created by Wholly-iOS on 22/08/18.
//  Copyright © 2018 GauravkumarGudaliya. All rights reserved.
//

import UIKit

class AGTableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        defaultInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        defaultInit()
    }
    
    func defaultInit(){
        self.keyboardDismissMode = .onDrag
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.isScrollEnabled = false
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if self.nsHeightConstraint != nil {
            self.nsHeightConstraint?.constant = self.contentSize.height
        }
        else if self.nsWidthConstraint != nil {
            self.nsWidthConstraint?.constant = self.contentSize.width
        }
    }
}
