//
//  UIViewController+extension.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/06/03.
//

import UIKit

extension UIViewController {
    static var nibName: String {
        let startIndex = className.startIndex
        let endIndex = className.firstIndex(of: "<") ?? className.endIndex
        return String(className[startIndex ..< endIndex])
    }
}
