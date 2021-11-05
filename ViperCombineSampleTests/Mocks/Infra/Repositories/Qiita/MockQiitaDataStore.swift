//
//  MockQiitaDataStore.swift
//  ViperCombineSampleTests
//
//  Created by hicka04 on 2021/06/25.
//

@testable import ViperCombineSample
import Combine

final class MockQiitaDataStore: QiitaRepository {
    private(set) var searchArticlesCallCount = 0
    let searchArticlesResult = PassthroughSubject<[ArticleModel], QiitaRepositoryError>()
    func searchArticles(keyword: String) -> AnyPublisher<[ArticleModel], QiitaRepositoryError> {
        searchArticlesCallCount += 1
        return searchArticlesResult.eraseToAnyPublisher()
    }
}
