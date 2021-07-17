//
//  UsecaseError.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/05/21.
//

import Foundation

protocol UsecaseError: Error, Equatable {
    var message: String { get }
}

extension Never: UsecaseError {
    var message: String {
        fatalError()
    }
}
