//
//  NSObject+Helper.swift
//  CatalogPro
//
//  Created by Swapnil Vinayak Shinde on 2025-12-29.
//

import Foundation

extension NSObject {
    
    class var className: String {
        return "\(self)"
    }
    
    var className: String {
        return String(describing: type(of: self))
    }
    
}
