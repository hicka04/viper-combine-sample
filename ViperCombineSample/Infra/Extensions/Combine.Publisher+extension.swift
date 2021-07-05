//
//  Combine.Publisher+extension.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/07/05.
//

import Foundation
import Combine

extension Publisher {
    func convertToResultPublisher() -> AnyPublisher<Result<Output, Failure>, Never> {
        self.map { .success($0) }
            .catch { error in
                Just(.failure(error))
            }.eraseToAnyPublisher()
    }
}
