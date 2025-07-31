//
//  UITableView+Extension.swift
//  BaseProject
//
//  Created by GauravkumarGudaliya on 12/02/18.
//  Copyright © 2018 GauravkumarGudaliya. All rights reserved.
//

import UIKit

extension UITableView {
    
    public func estimatedRowHeight(_ height: CGFloat) {
        self.rowHeight = UITableView.automaticDimension
        self.estimatedRowHeight = height
    }
    
    public func estimatedSectionHeaderHeight(_ height: CGFloat) {
        self.sectionHeaderHeight = UITableView.automaticDimension
        self.estimatedSectionHeaderHeight = height
    }
    
    public func estimatedSectionFooterHeight(_ height: CGFloat) {
        self.sectionFooterHeight = UITableView.automaticDimension
        self.estimatedSectionFooterHeight = height
    }
    
    public func hideEmptyCells() {
        self.tableFooterView = UIView(frame: .zero)
    }
    
    public func indexPaths(section: Int) -> [IndexPath] {
        var indexPaths: [IndexPath] = []
        let rows: Int = self.numberOfRows(inSection: section)
        for i in 0 ..< rows {
            let indexPath: IndexPath = IndexPath(row: i, section: section)
            indexPaths.append(indexPath)
        }
        
        return indexPaths
    }
    
    func reloadSection(withSection sectionIndex: Int? = nil, animation: UITableView.RowAnimation = .none){
        if let index = sectionIndex {
            let indexSet = IndexSet.init(integer: index)
            reloadSections(indexSet, with: animation)
        }
        else{
            let range = Range(0...self.numberOfSections)
            let indexSet = IndexSet(integersIn: range)
            reloadSections(indexSet, with: animation)
        }
    }
    
    enum ReloadDataType {
        case `default`
        case transform
        case viewAnimation(type: UIView.AnimationOptions)
    }
    
    public func reloadDataAsync() {
        DispatchQueue.main.async {[weak self] in
            self?.reloadData()
        }
    }
    
    func reloadData(withAnimation type: ReloadDataType = .default, completion: @escaping (() -> ())) {
        
        switch type {
        case .transform:
            
            let tableHeight: CGFloat = self.bounds.size.height
            var index = 0
//            self.reloadData()
            for cell in self.visibleCells {
                cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
                UIView.animate(withDuration: 1.0, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0);
                }, completion:{ _ in
                    if self.visibleCells.last == cell {
                        completion()
                    }
                })
                index += 1
            }
            break
            
        case .viewAnimation(let option):
            UIView.transition(with: self, duration: 1.00, options: option, animations: {
                self.reloadData()
            }, completion:{ _ in
                completion()
            })
            
        default:
            UIView.animate(withDuration: 0, animations: {
                self.reloadData()
            }, completion:{ _ in
                completion()
            })
            break
        }
    }
    
    public func totalRows() -> Int {
        var i = 0
        var rowCount = 0
        while i < self.numberOfSections {
            rowCount += self.numberOfRows(inSection: i)
            i += 1
        }
        return rowCount
    }
    
    public var lastIndexPath: IndexPath? {
        if (self.totalRows()-1) > 0{
            return IndexPath(row: self.totalRows()-1, section: 0)
        } else {
            return nil
        }
    }
    
    /// Retrive the next index path for the given row at section.
    public func nextIndexPath(row: Int, forSection section: Int) -> IndexPath? {
        let indexPath: [IndexPath] = self.indexPaths(section: section)
        guard indexPath != [] else {
            return nil
        }
        
        return indexPath[row + 1]
    }
    
    /// Retrive the previous index path for the given row at section
    public func previousIndexPath(row: Int, forSection section: Int) -> IndexPath? {
        let indexPath: [IndexPath] = self.indexPaths(section: section)
        guard indexPath != [] else {
            return nil
        }
        
        return indexPath[row - 1]
    }
    
    func deleteRow(row: Int, section: Int, with: UITableView.RowAnimation, completion: @escaping (() -> ())) {
        UIView.animate(withDuration: 0, animations: {
            
            if self.numberOfRows(inSection: section) != 1 {
                self.deleteRows(at: [IndexPath(row: row, section: section)], with: with)
            }
            else{
                self.reloadData()
            }
        }, completion:{ _ in
            completion()
        })
    }
    
    func scroll(to: ScrollsTo, animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {[weak self] in
            let numberOfSections = self?.numberOfSections
            let numberOfRows = self?.numberOfRows(inSection: (numberOfSections ?? 1)-1)
            
            guard let numberOfRows = numberOfRows, numberOfRows > 0 else { return }
            switch to{
            case .top:
                let indexPath = IndexPath(row: 0, section: 0)
                self?.scrollToRow(at: indexPath, at: .top, animated: animated)
                break
                
            case .bottom:
                let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections! - 1))
                self?.scrollToRow(at: indexPath, at: .bottom, animated: animated)
                break
            }
        }
    }
    
    enum ScrollsTo {
        case top,bottom
    }
}

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(withClassIdentifier cell: T.Type, for indexPath: IndexPath) -> T {
        if let Cell = self.dequeueReusableCell(withIdentifier: String(describing: cell.self), for: indexPath) as? T{
            return Cell
        }
        fatalError(String(describing: cell.self))
    }
    
    func dequeueReusableCell<T : UITableViewCell>(withClassIdentifier cell: T.Type) -> T {
        if let Cell = dequeueReusableCell(withIdentifier: String(describing: cell.self)) as? T {
            return Cell
        }
        fatalError(String(describing: cell.self))
    }
    
    func registerNib(_ cellClass: UITableViewCell.Type) {
        let id = String(describing: cellClass.self)
        let nib = UINib(nibName: id, bundle: nil)
        register(nib, forCellReuseIdentifier: id)
    }
    
    func register(_ cellClass: Swift.AnyClass) {
        register(cellClass, forCellReuseIdentifier: String(describing: cellClass.self))
    }
}
