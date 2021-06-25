//
//  QiitaRepository.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/05/29.
//

import Foundation
import Combine

enum QiitaRepositoryError: Error {
    case connectionError(Error)
    case requestError(Error)
    case responseError(Error)
}

protocol QiitaRepository: AnyObject {
    func searchArticles(keyword: String) -> AnyPublisher<[ArticleModel], QiitaRepositoryError>
}
