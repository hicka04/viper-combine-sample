//
//  UsecaseError.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/05/21.
//

import Foundation

protocol UsecaseError: LocalizedError, Equatable {}

extension Never: UsecaseError {}
