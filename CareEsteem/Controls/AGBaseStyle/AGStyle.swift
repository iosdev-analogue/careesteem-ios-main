//
//  AGStyle.swift
//  BaseProject
//
//  Created by Gauravkumar Gudaliya on 24/06/18.
//  Copyright © 2018 GauravkumarGudaliya. All rights reserved.
//

import UIKit

extension UIResponder: AGStyleCompatible { }

public class AGStyle<Base> {
    
    public let base: Base
    
    public init(base: Base) {
        self.base = base
    }
}

public protocol AGStyleCompatible {
    associatedtype CompatibleType
    var ag: CompatibleType { get }
}

public extension AGStyleCompatible {
    var ag: AGStyle<Self> {
        get { return AGStyle(base: self) }
    }
}
