//
//  AGCollectionView.swift
//  MyShopOnWeb
//
//  Created by Gauravkumar Gudaliya on 30/03/18.
//  Copyright © 2018 GauravkumarGudaliya.. All rights reserved.
//

import UIKit

extension AGStyle where Base: UICollectionView {
    
    func keyboardDismissMode( _ newValue: UIScrollView.KeyboardDismissMode) -> Self {
        base.keyboardDismissMode = newValue
        return self
    }
    
    @discardableResult
    func showScrollIndicator(vertical: Bool, horizontal: Bool) -> Self {
        base.showsVerticalScrollIndicator = vertical
        base.showsHorizontalScrollIndicator = horizontal
        return self
    }
    
    @discardableResult
    func delegateDataSource(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource)  -> Self {
        base.delegate = delegate
        base.dataSource = dataSource
        return self
    }
    
    @discardableResult
    func contentInset(_ edgeInsets: UIEdgeInsets)  -> Self {
        base.contentInset = edgeInsets
        return self
    }
    
    @discardableResult
    func registerNib(_ cellClass: UICollectionViewCell.Type) -> Self{
        let id = String(describing: cellClass.self)
        let nib = UINib(nibName: id, bundle: nil)
        base.register(nib, forCellWithReuseIdentifier: id)
        return self
    }
    
    @discardableResult
    func register(_ cellClass: Swift.AnyClass) -> Self{
        base.register(cellClass, forCellWithReuseIdentifier: String(describing: cellClass.self))
        return self
    }
}
