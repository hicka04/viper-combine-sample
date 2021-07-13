//
//  ArticleSearchPresenterTests.swift
//  ViperCombineSampleTests
//
//  Created by hicka04 on 2021/06/05.
//

@testable import ViperCombineSample
import Quick
import Nimble
import Combine
import CombineSchedulers

final class ArticleSearchPresenterTests: QuickSpec {
    override func spec() {
        var testScheduler: TestSchedulerOf<DispatchQueue>!
        
        var presenter: ArticleSearchPresenter!
        var router: MockArticleSearchRouter!
        var articleSearchInteractor: MockArticleSearchInteractor!
        
        beforeEach {
            testScheduler = DispatchQueue.test
            
            router = .init()
            articleSearchInteractor = .init()
            presenter = .init(
                mainScheduler: .immediate,
                router: router,
                articleSearchInteractor: articleSearchInteractor
            )
        }
        
        describe("viewDidLoad") {
            let articles = [
                ArticleModel(id: .init(rawValue: "article_id"), title: "article_title", body: "article_body")
            ]
            
            beforeEach {
                articleSearchInteractor.executeResult = Future { promise in
                    testScheduler.schedule(after: testScheduler.now.advanced(by: 10)) {
                        promise(.success(articles))
                    }
                }.eraseToAnyPublisher()
                
                presenter.viewEventSubject.send(.viewDidLoad)
            }
            
            it("articlesが更新される") {
                expect(presenter.articles) == []
                testScheduler.advance(by: 10)
                expect(presenter.articles) == articles
            }
        }
    }
}

extension ArticleSearchPresenterTests {
    final class MockArticleSearchRouter: ArticleSearchWireframe {
        private(set) var navigateCallArguments: [ArticleSearchDestination] = []
        var navigateCallCount: Int {
            navigateCallArguments.count
        }
        func navigatie(to destination: ArticleSearchDestination) {
            navigateCallArguments.append(destination)
        }
    }
}
