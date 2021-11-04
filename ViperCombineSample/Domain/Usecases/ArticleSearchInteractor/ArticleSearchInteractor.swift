//
//  ArticleSearchInteractor.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/05/21.
//

import Foundation
import Combine

struct ArticleSearchError: UsecaseError, Identifiable {
    private let error: QiitaRepositoryError
    
    var errorDescription: String {
        switch error {
        case .connectionError:
            return "ネットワークエラーが発生しました"
        case .requestError:
            return "予期せぬエラーが発生しました"
        case .responseError:
            return "検索に失敗しました"
        }
    }
    
    var recoverySuggestion: String? {
        switch error {
        case .connectionError:
            return "通信環境を確認して再度お試しください"
        case .requestError:
            return nil
        case .responseError:
            return "時間をおいて再度お試しください"
        }
    }
    
    var id: String {
        error.localizedDescription
    }
    
    init(error: QiitaRepositoryError) {
        self.error = error
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
