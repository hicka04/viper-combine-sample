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
        var articleSearchErrorOutputs: [ArticleSearchError?] = []
        var navigationOutputs: [ArticleSearchDestination] = []
        
        beforeEach {
            testScheduler = DispatchQueue.test
            
            router = .init()
            articleSearchInteractor = .init()
            presenter = .init(
                mainScheduler: testScheduler.eraseToAnyScheduler(),
                router: router,
                articleSearchInteractor: articleSearchInteractor
            )
            
            presenter.$articles.sink { articlesOutputs.append($0) }.store(in: &cancellables)
            presenter.$articleSearchError.sink { articleSearchErrorOutputs.append($0) }.store(in: &cancellables)
            router.navigationSubject.sink { navigationOutputs.append($0) }.store(in: &cancellables)
        }
        
        afterEach {
            cancellables = []
            articlesOutputs = []
            articleSearchErrorOutputs = []
            navigationOutputs = []
        }
        
        describe("viewDidLoad") {
            beforeEach {
                testScheduler.schedule {
                    presenter.viewEventSubject.send(.viewDidLoad)
                }
            }
            
            context("articleSearchInteractorの返却値がエラーのとき") {
                let error = ArticleSearchError(error: .connectionError(NSError(domain: "hoge", code: -1, userInfo: nil)))
                
                beforeEach {
                    testScheduler.schedule(after: testScheduler.now.advanced(by: 10)) {
                        articleSearchInteractor.executeResult.send(completion: .failure(error))
                    }
                    
                    testScheduler.advance(by: 10)
                }
                
                it("articleSearchErrorが更新される") {
                    expect(articleSearchErrorOutputs) == [
                        nil,
                        error
                    ]
                }
            }
            
            context("articleSearchInteractorの返却値が成功のとき") {
                let articles = [
                    ArticleModel(id: .init(rawValue: "article_id"), title: "article_title", body: "article_body")
                ]
                
                beforeEach {
                    testScheduler.schedule(after: testScheduler.now.advanced(by: 10)) {
                        articleSearchInteractor.executeResult.send(articles)
                    }
                    
                    testScheduler.advance(by: 10)
                }
                
                it("articlesが更新される") {
                    expect(articlesOutputs) == [
                        [],
                        .init(articles)
                    ]
                }
            }
        }
        
        describe("refreshControlValueChanged") {
            beforeEach {
                testScheduler.schedule {
                    presenter.viewEventSubject.send(.refreshControlValueChanged)
                }
            }
            
            context("articleSearchInteractorの返却値がエラーのとき") {
                let error = ArticleSearchError(error: .connectionError(NSError(domain: "hoge", code: -1, userInfo: nil)))
                
                beforeEach {
                    testScheduler.schedule(after: testScheduler.now.advanced(by: 10)) {
                        articleSearchInteractor.executeResult.send(completion: .failure(error))
                    }
                    
                    testScheduler.advance(by: 10)
                }
                
                it("articleSearchErrorが更新される") {
                    expect(articleSearchErrorOutputs) == [
                        nil,
                        error
                    ]
                }
            }
            
            context("articleSearchInteractorの返却値が成功のとき") {
                let articles = [
                    ArticleModel(id: .init(rawValue: "article_id"), title: "article_title", body: "article_body")
                ]
                
                beforeEach {
                    testScheduler.schedule(after: testScheduler.now.advanced(by: 10)) {
                        articleSearchInteractor.executeResult.send(articles)
                    }
                    
                    testScheduler.advance(by: 10)
                }
                
                it("articlesが更新される") {
                    expect(articlesOutputs) == [
                        [],
                        .init(articles)
                    ]
                }
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
