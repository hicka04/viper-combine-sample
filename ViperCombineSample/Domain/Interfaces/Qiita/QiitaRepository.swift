//
//  QiitaRepository.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/05/29.
//

import Foundation
import Combine

enum QiitaRepositoryError: Error, Equatable {
    case connectionError(Error)
    case requestError(Error)
    case responseError(Error)
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.connectionError, connectionError),
             (.requestError, .requestError),
             (.responseError, .responseError):
            return true
            
        default:
            return false
        }
    }
}

protocol QiitaRepository: AnyObject {
    func searchArticles(keyword: String) -> AnyPublisher<[ArticleModel], QiitaRepositoryError>
}
