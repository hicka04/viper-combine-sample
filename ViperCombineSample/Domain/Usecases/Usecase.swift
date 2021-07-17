//
//  Usecase.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/05/21.
//

import Foundation
import Combine

protocol Usecase {
    associatedtype Input
    associatedtype Output
    associatedtype Failure: UsecaseError
    
    func execute(_ input: Input) -> AnyPublisher<Output, Failure>
}
