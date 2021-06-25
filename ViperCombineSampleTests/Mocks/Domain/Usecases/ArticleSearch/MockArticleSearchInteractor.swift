//
//  MockArticleSearchInteractor.swift
//  ViperCombineSampleTests
//
//  Created by hicka04 on 2021/06/05.
//

@testable import ViperCombineSample
import Combine

final class MockArticleSearchInteractor: ArticleSearchUsecase {
    private(set) var executeCallCount = 0
    var executeResult: AnyPublisher<[ArticleModel], ArticleSearchError>!
    func execute(_ input: String) -> AnyPublisher<[ArticleModel], ArticleSearchError> {
        executeCallCount += 1
        return executeResult
    }
}
