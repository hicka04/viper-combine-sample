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
        var cancellables: Set<AnyCancellable> = []
        var testScheduler: TestSchedulerOf<DispatchQueue>!
        
        var presenter: ArticleSearchPresenter!
        var router: MockArticleSearchRouter!
        var articleSearchInteractor: MockArticleSearchInteractor!
        
        var articlesOutputs: [[ArticleModel]] = []
        var navigationOutputs: [ArticleSearchDestination] = []
        
        beforeEach {
            testScheduler = DispatchQueue.test
            
            router = .init()
            articleSearchInteractor = .init()
            presenter = .init(
                mainScheduler: .immediate,
                router: router,
                articleSearchInteractor: articleSearchInteractor
            )
            
            presenter.$articles.sink { articlesOutputs.append($0) }.store(in: &cancellables)
            router.navigationSubject.sink { navigationOutputs.append($0) }.store(in: &cancellables)
        }
        
        afterEach {
            cancellables = []
            articlesOutputs = []
            navigationOutputs = []
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
                
                testScheduler.schedule {
                    presenter.viewEventSubject.send(.viewDidLoad)
                }
                
                testScheduler.advance(by: 10)
            }
            
            it("articlesが更新される") {
                expect(articlesOutputs) == [
                    [],
                    articles
                ]
            }
        }
        
        describe("didSelectArticle") {
            let article = ArticleModel(id: .init(rawValue: "article_id"), title: "article_title", body: "article_body")
            
            beforeEach {
                testScheduler.schedule {
                    presenter.viewEventSubject.send(.didSelect(article: article))
                }
                
                testScheduler.advance()
            }
            
            it("articleDetailViewへ遷移する") {
                expect(navigationOutputs) == [
                    .articleDetail(article)
                ]
            }
        }
    }
}

extension ArticleSearchPresenterTests {
    final class MockArticleSearchRouter: ArticleSearchWireframe {
        let navigationSubject = PassthroughSubject<ArticleSearchDestination, Never>()
    }
}
