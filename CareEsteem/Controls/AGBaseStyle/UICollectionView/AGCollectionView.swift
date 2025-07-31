//
//  AGCollectionView.swift
//  BaseProject
//
//  Created by Wholly-iOS on 22/08/18.
//  Copyright © 2018 GauravkumarGudaliya. All rights reserved.
//

import UIKit

class AGCollectionView: UICollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
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
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if self.nsHeightConstraint != nil {
            self.nsHeightConstraint?.constant = floor(self.contentSize.height)
        }
        else if self.nsWidthConstraint != nil {
            self.nsWidthConstraint?.constant = floor(self.contentSize.width)
        }
        else{
            sizeToFit()
            print("Set a nsHeightConstraint to set cocontentSize with same")
        }
    }
}
