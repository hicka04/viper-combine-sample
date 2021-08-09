//
//  PaginationPublisher.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/07/22.
//

import Foundation
import Combine
import APIKit

extension QiitaDataStore {
    func paginationPublisher<R: PaginableQiitaRequest>(request: R, session: Session) -> PaginationPublisher<R> {
        PaginationPublisher(request: request, session: session)
    }
    
    struct PaginationPublisher<R: PaginableQiitaRequest>: Publisher {
        typealias Output = R.Response
        typealias Failure = QiitaRepositoryError
        
        let request: R
        let session: Session
        
        func receive<S>(subscriber: S) where S : Subscriber, QiitaRepositoryError == S.Failure, R.Response == S.Input {
            subscriber.receive(subscription: Subscription(subscriber: subscriber, request: request, session: session))
        }
    }
    
    private final class Subscription<S: Subscriber, R: PaginableQiitaRequest>: Combine.Subscription where S.Input == R.Response, S.Failure == QiitaRepositoryError {
        private var subscriber: S?
        private var request: R
        private let session: Session
        
        init(subscriber: S, request: R, session: Session) {
            self.subscriber = subscriber
            self.request = request
            self.session = session
        }
        
        func request(_ demand: Subscribers.Demand) {
            guard demand == 1 else {
                subscriber?.receive(completion: .failure(.requestError(NSError(domain: "UnexpectedDemandError", code: -1, userInfo: ["demand": demand]))))
                return
            }
            
            session.send(request) { result in
                switch result {
                case .success(let pageResponse):
                    if let nextPageIndex = pageResponse.nextPageIndex {
                        self.request.page = nextPageIndex
                    }
                    _ = self.subscriber?.receive(pageResponse)
                    
                    if pageResponse.nextPageIndex == nil {
                        self.subscriber?.receive(completion: .finished)
                        self.subscriber = nil
                    }
                    
                case .failure(let error):
                    switch error {
                    case .connectionError(let error):
                        self.subscriber?.receive(completion: .failure(.connectionError(error)))
                        
                    case .responseError(let error):
                        self.subscriber?.receive(completion: .failure(.responseError(error)))
                        
                    case .requestError(let error):
                        self.subscriber?.receive(completion: .failure(.requestError(error)))
                    }
                }
            }
        }
        
        func cancel() {
            subscriber = nil
        }
    }
}
