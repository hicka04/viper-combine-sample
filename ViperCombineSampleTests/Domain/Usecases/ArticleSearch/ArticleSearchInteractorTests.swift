//
//  ArticleSearchInteractorTests.swift
//  ViperCombineSampleTests
//
//  Created by hicka04 on 2021/06/25.
//

@testable import ViperCombineSample
import Foundation
import Quick
import Nimble
import EntwineTest

final class ArticleSearchInteractorTests: QuickSpec {
    override func spec() {
        var testScheduler: TestScheduler!
        var testableSubscriber: TestableSubscriber<ArticleSearchInteractor.Output, ArticleSearchInteractor.Failure>!
        
        var interactor: ArticleSearchInteractor!
        var qiitaDataStore: MockQiitaDataStore!
        let error = NSError(domain: "hoge", code: -1, userInfo: nil)
        
        beforeEach {
            testScheduler = .init(initialClock: 0)
            testableSubscriber = testScheduler.createTestableSubscriber(ArticleSearchInteractor.Output.self, ArticleSearchInteractor.Failure.self)
            
            qiitaDataStore = .init()
            interactor = .init(qiitaRepository: qiitaDataStore)
        }
        
        describe("execute") {
            context("dataStoreの返却値がconnectionErrorのとき") {
                let connectionError: QiitaRepositoryError = .connectionError(error)
                
                beforeEach {
                    qiitaDataStore.searchArticlesResult = testScheduler.createRelativeTestablePublisher([
                        (10, .completion(.failure(connectionError)))
                    ]).eraseToAnyPublisher()
                    
                    interactor.execute("Swift")
                        .subscribe(testableSubscriber)
                    
                    testScheduler.resume()
                }
                
                it("エラーが返却される") {
                    expect(testableSubscriber.recordedOutput) == [
                        (0, .subscription),
                        (10, .completion(.failure(.init(error: connectionError))))
                    ]
                }
            }
            
            context("dataStoreの返却値がrequestErrorのとき") {
                let requestError: QiitaRepositoryError = .requestError(error)
                
                beforeEach {
                    qiitaDataStore.searchArticlesResult = testScheduler.createRelativeTestablePublisher([
                        (10, .completion(.failure(requestError)))
                    ]).eraseToAnyPublisher()
                    
                    interactor.execute("Swift")
                        .subscribe(testableSubscriber)
                    
                    testScheduler.resume()
                }
                
                it("エラーが返却される") {
                    expect(testableSubscriber.recordedOutput) == [
                        (0, .subscription),
                        (10, .completion(.failure(.init(error: requestError))))
                    ]
                }
            }
            
            context("dataStoreの返却値がresponseErrorのとき") {
                let responseError: QiitaRepositoryError = .responseError(error)
                
                beforeEach {
                    qiitaDataStore.searchArticlesResult = testScheduler.createRelativeTestablePublisher([
                        (10, .completion(.failure(responseError)))
                    ]).eraseToAnyPublisher()
                    
                    interactor.execute("Swift")
                        .subscribe(testableSubscriber)
                    
                    testScheduler.resume()
                }
                
                it("エラーが返却される") {
                    expect(testableSubscriber.recordedOutput) == [
                        (0, .subscription),
                        (10, .completion(.failure(.init(error: responseError))))
                    ]
                }
            }
            
            context("dataStoreの返却値が成功のとき") {
                let response = [
                    ArticleModel(id: .init(rawValue: "article_id"), title: "article_title", body: "article_body")
                ]
                
                beforeEach {
                    qiitaDataStore.searchArticlesResult = testScheduler.createRelativeTestablePublisher([
                        (10, .input(response))
                    ]).eraseToAnyPublisher()
                    
                    interactor.execute("Swift")
                        .subscribe(testableSubscriber)
                    
                    testScheduler.resume()
                }
                
                it("[ArticleModel]が返却される") {
                    expect(testableSubscriber.recordedOutput) == [
                        (0, .subscription),
                        (10, .input(response))
                    ]
                }
            }
        }
    }
}
