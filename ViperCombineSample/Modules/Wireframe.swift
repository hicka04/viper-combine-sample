//
//  Wireframe.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/05/21.
//

import Foundation
import Combine

protocol Wireframe: AnyObject {
    associatedtype Destination
    
    var navigationSubject: PassthroughSubject<Destination, Never> { get }
}
