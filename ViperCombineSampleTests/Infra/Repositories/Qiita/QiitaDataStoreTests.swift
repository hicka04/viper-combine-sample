//
//  QiitaDataStoreTests.swift
//  ViperCombineSampleTests
//
//  Created by hicka04 on 2021/06/27.
//

@testable import ViperCombineSample
import Quick
import Nimble
import EntwineTest
import OHHTTPStubs
import OHHTTPStubsSwift
import Combine

final class QiitaDataStoreTests: QuickSpec {
    override func spec() {
        var dataStore: QiitaDataStore!
        var cancellables: Set<AnyCancellable> = []
        
        beforeEach {
            dataStore = .init()
        }
        
        afterEach {
            HTTPStubs.removeAllStubs()
            cancellables = []
        }
        
        describe("searchArticles") {
            context("ネットワークがつながっていないとき") {
                beforeEach {
                    stub(condition: isHost("qiita.com") && isPath("/api/v2/items")) { _ in
                        HTTPStubsResponse(
                            error: NSError(domain: "hoge", code: -1, userInfo: nil)
                        )
                    }
                }
                
                it("connectionErrorが返却される") {
                    waitUntil { done in
                        dataStore.searchArticles(keyword: "Swift")
                            .sink { completion in
                                switch completion {
                                case .failure(.connectionError):
                                    done()
                                    
                                default:
                                    fail()
                                }
                            } receiveValue: { _ in
                                fail()
                            }.store(in: &cancellables)
                    }
                }
            }
            
            context("ステータスコードが200以外のとき") {
                beforeEach {
                    stub(condition: isHost("qiita.com") && isPath("/api/v2/items")) { _ in
                        return HTTPStubsResponse(data: .init(), statusCode: .random(in: 300 ..< 600), headers: nil)
                    }
                }
                
                it("responseErrorが返却される") {
                    waitUntil { done in
                        dataStore.searchArticles(keyword: "Swift")
                            .sink { completion in
                                switch completion {
                                case .failure(.responseError):
                                    done()
                                    
                                default:
                                    fail()
                                }
                            } receiveValue: { _ in
                                fail()
                            }.store(in: &cancellables)
                    }
                }
            }
            
            context("パースできないとき") {
                beforeEach {
                    stub(condition: isHost("qiita.com") && isPath("/api/v2/items")) { _ in
                        let data = try! JSONSerialization.data(withJSONObject: ["hoge": "fuga"], options: .fragmentsAllowed)
                        return HTTPStubsResponse(data: data, statusCode: 200, headers: nil)
                    }
                }
                
                it("responseErrorが返却される") {
                    waitUntil { done in
                        dataStore.searchArticles(keyword: "Swift")
                            .sink { completion in
                                switch completion {
                                case .failure(.responseError):
                                    done()
                                    
                                default:
                                    fail()
                                }
                            } receiveValue: { _ in
                                fail()
                            }.store(in: &cancellables)
                    }
                }
            }
            
            context("レスポンスが正常なとき") {
                beforeEach {
                    stub(condition: isHost("qiita.com") && isPath("/api/v2/items")) { _ in
                        let jsonObject = [
                            [
                                "id": "article_id",
                                "title": "article_title",
                                "body": "article_body"
                            ]
                        ]
                        let data = try! JSONSerialization.data(withJSONObject: jsonObject, options: .fragmentsAllowed)
                        return HTTPStubsResponse(data: data, statusCode: 200, headers: nil)
                    }
                }
                
                it("[ArticleModel]が返却される") {
                    waitUntil { done in
                        dataStore.searchArticles(keyword: "Swift")
                            .sink { completion in
                                switch completion {
                                case .failure:
                                    fail()
                                    
                                case .finished:
                                    done()
                                }
                            } receiveValue: { articles in
                                expect(articles.count) == 1
                            }.store(in: &cancellables)
                    }
                }
            }
        }
    }
}
