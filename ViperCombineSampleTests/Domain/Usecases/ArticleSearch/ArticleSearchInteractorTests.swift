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
import Combine
import CombineSchedulers

final class ArticleSearchInteractorTests: QuickSpec {
    override func spec() {
        var cancellables: Set<AnyCancellable> = []
        var testScheduler: TestSchedulerOf<DispatchQueue>!
        var executeOutputs: [Result<ArticleSearchInteractor.Output, ArticleSearchInteractor.Failure>] = []
        
        var interactor: ArticleSearchInteractor!
        var qiitaDataStore: MockQiitaDataStore!
        
        let input: ArticleSearchInteractor.Input = "Swift"
        let error = NSError(domain: "hoge", code: -1, userInfo: nil)
        
        beforeEach {
            testScheduler = DispatchQueue.test
            
            qiitaDataStore = .init()
            interactor = .init(qiitaRepository: qiitaDataStore)
        }
        
        afterEach {
            cancellables = []
            executeOutputs = []
        }
        
        describe("execute") {
            beforeEach {
                testScheduler.schedule {
                    interactor.execute(input)
                        .convertToResultPublisher()
                        .sink { executeOutputs.append($0) }
                        .store(in: &cancellables)
                }
            }
            context("dataStoreの返却値がconnectionErrorのとき") {
                let connectionError: QiitaRepositoryError = .connectionError(error)
                
                beforeEach {
                    testScheduler.schedule(after: testScheduler.now.advanced(by: 10)) {
                        qiitaDataStore.searchArticlesResult.send(completion: .failure(connectionError))
                    }
                    
                    testScheduler.advance(by: 10)
                }
                
                it("エラーが返却される") {
                    expect(executeOutputs) == [
                        .failure(.init(error: connectionError))
                    ]
                }
            }
            
            context("dataStoreの返却値がrequestErrorのとき") {
                let requestError: QiitaRepositoryError = .requestError(error)
                
                beforeEach {
                    testScheduler.schedule(after: testScheduler.now.advanced(by: 10)) {
                        qiitaDataStore.searchArticlesResult.send(completion: .failure(requestError))
                    }
                    
                    testScheduler.advance(by: 10)
                }
                
                it("エラーが返却される") {
                    expect(executeOutputs) == [
                        .failure(.init(error: requestError))
                    ]
                }
            }
            
            context("dataStoreの返却値がresponseErrorのとき") {
                let responseError: QiitaRepositoryError = .responseError(error)
                
                beforeEach {
                    testScheduler.schedule(after: testScheduler.now.advanced(by: 10)) {
                        qiitaDataStore.searchArticlesResult.send(completion: .failure(responseError))
                    }
                    
                    testScheduler.advance(by: 10)
                }
                
                it("エラーが返却される") {
                    expect(executeOutputs) == [
                        .failure(.init(error: responseError))
                    ]
                }
            }
            
            context("dataStoreの返却値が成功のとき") {
                let response = [
                    ArticleModel(id: .init(rawValue: "article_id"), title: "article_title", body: "article_body")
                ]
                
                beforeEach {
                    testScheduler.schedule(after: testScheduler.now.advanced(by: 10)) {
                        qiitaDataStore.searchArticlesResult.send(response)
                    }
                    
                    testScheduler.advance(by: 10)
                }
                
                it("[ArticleModel]が返却される") {
                    expect(executeOutputs) == [
                        .success(response)
                    ]
                }
            }
        }
    }
}
