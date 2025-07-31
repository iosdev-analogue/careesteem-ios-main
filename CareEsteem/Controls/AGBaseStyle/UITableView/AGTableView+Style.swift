//
//  AGTableView.swift
//  BaseProject
//
//  Created by Gauravkumar Gudaliya on 12/22/17.
//  Copyright © 2017 GauravkumarGudaliya. All rights reserved.
//

import UIKit

extension AGStyle where Base: UITableView {
    @discardableResult
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
    func delegateDataSource(delegate: UITableViewDelegate, dataSource: UITableViewDataSource)  -> Self {
        base.delegate = delegate
        base.dataSource = dataSource
        return self
    }
    
    @discardableResult
    func registerNib(_ cellClass: UITableViewCell.Type) -> Self{
        let id = String(describing: cellClass.self)
        let nib = UINib(nibName: id, bundle: nil)
        base.register(nib, forCellReuseIdentifier: id)
        return self
    }
    
    @discardableResult
    func registerNib(_ cellClass: UITableViewCell.Type, identifier: UITableViewCell.Type) -> Self{
        let id = String(describing: identifier.self)
        return self.registerNib(cellClass, identifier: id)
    }
    
    @discardableResult
    func registerNib(_ cellClass: UITableViewCell.Type, identifier: String) -> Self{
        let id = String(describing: cellClass.self)
        let nib = UINib(nibName: id, bundle: nil)
        base.register(nib, forCellReuseIdentifier: identifier)
        return self
    }
    
    @discardableResult
    func register(_ cellClass: Swift.AnyClass) -> Self{
        base.register(cellClass, forCellReuseIdentifier: String(describing: cellClass.self))
        return self
    }
}
