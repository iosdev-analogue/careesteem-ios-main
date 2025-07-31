//
//  UICollectionView+Man.swift
//  BaseProject
//
//  Created by Gauravkumar Gudaliya on 31/01/19.
//  Copyright © 2017 GauravkumarGudaliya. All rights reserved.
//


import UIKit

extension UICollectionView {
    
    /// Returns a reusable table-view cell object for the specified reuse identifier and adds it to the table.
    /// Note: withIdentifier must be equal to the Cell Class.
    func dequeueReusableCell<T : UICollectionViewCell>(with cell: T.Type, for indexPath: IndexPath) -> T {
        if let Cell = self.dequeueReusableCell(withReuseIdentifier: String(describing: cell.self), for: indexPath) as? T{
            return Cell
        }
        fatalError(String(describing: cell.self))
    }
    
    /// Registers a nib object containing a cell with the table view under a specified identifier.
    /// Nib name must be equal to the Cell Class, and the forCellReuseIdentifier must equal to Cell Class as well.
    func registerNib(_ cellClass: UICollectionViewCell.Type) {
        let id = String(describing: cellClass.self)
        let nib = UINib(nibName: id, bundle: nil)
        register(nib, forCellWithReuseIdentifier: id)
    }
    
    /// Registers a class for use in creating new table cells.
    /// Note: forCellReuseIdentifier must equal to the Cell Class.
    func register(_ cellClass: Swift.AnyClass) {
        register(cellClass, forCellWithReuseIdentifier: String(describing: cellClass.self))
    }
}

public extension UICollectionView {

    func reloadData(_ completion:  (()->Void)? = nil) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            completion?()
        })
    }

    func scroll(to: ScrollsTo, animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) { [weak self] in
            let numberOfSections = self?.numberOfSections
            let numberOfRows = self?.numberOfItems(inSection: (numberOfSections ?? 1)-1)
            
            guard (numberOfRows ?? 0) > 0 else { return }
            
            switch to{
            case .top:
                let indexPath = IndexPath(row: 0, section: 0)
                self?.scrollToItem(at: indexPath, at: .top, animated: animated)
                break
            case .bottom:
                let indexPath = IndexPath(row: numberOfRows!-1, section: (numberOfSections!-1))
                self?.scrollToItem(at: indexPath, at: .bottom, animated: animated)
                break
            }
        }
    }
    
    enum ScrollsTo {
        case top,bottom
    }
}
