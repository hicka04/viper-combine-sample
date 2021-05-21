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
    
}

extension ArticleSearchInteractor: ArticleSearchUsecase {
    func execute(_ input: String) -> AnyPublisher<[ArticleModel], ArticleSearchError> {
        Future { promise in
            promise(.success([ArticleModel(id: .init(rawValue: "article_id"), title: "article_title", body: "article_body")]))
        }
        .eraseToAnyPublisher()
    }
}
