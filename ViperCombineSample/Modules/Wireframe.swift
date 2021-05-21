//
//  Wireframe.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/05/21.
//

import Foundation

protocol Wireframe: AnyObject {
    associatedtype Destination
    
    func navigatie(to destination: Destination)
}
