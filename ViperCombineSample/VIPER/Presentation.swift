//
//  Presentation.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/06/02.
//

import Foundation
import Combine

protocol Presentation: ObservableObject {
    associatedtype ViewEvent
    
    var viewEventSubject: PassthroughSubject<ViewEvent, Never> { get }
}
