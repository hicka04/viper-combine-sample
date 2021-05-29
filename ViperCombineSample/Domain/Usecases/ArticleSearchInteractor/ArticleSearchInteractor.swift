//
//  ArticleSearchInteractor.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/05/21.
//

import Foundation
import Combine

struct ArticleSearchError: UsecaseError {
    let message: String
    
    init(error: Error) {
        message = "\(error)"
    }
}

protocol ArticleSearchUsecase: Usecase
where Input == String,
      Output == [ArticleModel],
      Failure == ArticleSearchError {}

final class ArticleSearchInteractor {
    private let qiitaRepository: QiitaRepository
    
    init(qiitaRepository: QiitaRepository) {
        self.qiitaRepository = qiitaRepository
    }
}

extension ArticleSearchInteractor: ArticleSearchUsecase {
    func execute(_ input: String) -> AnyPublisher<[ArticleModel], ArticleSearchError> {
        qiitaRepository
            .searchArticles(keyword: input)
            .mapError { .init(error: $0) }
            .eraseToAnyPublisher()
    }
}
