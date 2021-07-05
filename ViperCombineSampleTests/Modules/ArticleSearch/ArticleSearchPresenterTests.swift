//
//  ArticleSearchPresenterTests.swift
//  ViperCombineSampleTests
//
//  Created by hicka04 on 2021/06/05.
//

@testable import ViperCombineSample
import Quick
import Nimble
import EntwineTest
import CombineSchedulers

final class ArticleSearchPresenterTests: QuickSpec {
    override func spec() {
        var testScheduler: EntwineTest.TestScheduler!
        var articlesSubscriber: TestableSubscriber<[ArticleModel], Never>!
        
        var presenter: ArticleSearchPresenter!
        var router: MockArticleSearchRouter!
        var articleSearchInteractor: MockArticleSearchInteractor!
        
        beforeEach {
            testScheduler = .init(initialClock: 0)
            articlesSubscriber = testScheduler.createTestableSubscriber([ArticleModel].self, Never.self)
            
            router = .init()
            articleSearchInteractor = .init()
            presenter = .init(
                mainScheduler: .immediate,
                router: router,
                articleSearchInteractor: articleSearchInteractor
            )
            
            presenter.$articles.subscribe(articlesSubscriber)
        }
        
        describe("viewDidLoad") {
            let articles = [
                ArticleModel(id: .init(rawValue: "article_id"), title: "article_title", body: "article_body")
            ]
            
            beforeEach {
                articleSearchInteractor.executeResult = testScheduler.createRelativeTestablePublisher([
                    (10, .input(articles))
                ]).eraseToAnyPublisher()
                
                testScheduler.schedule(after: 10) { presenter.viewEventSubject.send(.viewDidLoad) }
                
                testScheduler.resume()
            }
            
            it("articlesが更新される") {
                expect(articlesSubscriber.recordedOutput) == [
                    (0, .subscription),
                    (0, .input([])),
                    (20, .input(articles))
                ]
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
