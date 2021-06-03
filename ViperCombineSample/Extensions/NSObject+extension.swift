//
//  NSObject+extension.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/06/03.
//

import UIKit

extension NSObject {
    static var className: String {
        String(describing: self)
    }
    
    var className: String {
        Self.className
    }
}
