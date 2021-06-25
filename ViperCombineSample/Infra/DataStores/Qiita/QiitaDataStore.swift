//
//  QiitaDataStore.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/05/29.
//

import Foundation
import APIKit
import Combine

final class QiitaDataStore {
    private let session: Session
    
    convenience init() {
        let adapter = URLSessionAdapter(configuration: .default)
        let session = Session(adapter: adapter, callbackQueue: .sessionQueue)
        self.init(session: session)
    }
    
    init(session: Session) {
        self.session = session
    }
}

extension QiitaDataStore: QiitaRepository {
    func searchArticles(keyword: String) -> AnyPublisher<[ArticleModel], QiitaRepositoryError> {
        session
            .sessionTaskPublisher(for: ArticleSearchRequest(keyword: keyword))
            .map { $0.map { $0.translate() } }
            .mapError { error in
                switch error {
                case .connectionError(let error):
                    return .connectionError(error)
                    
                case .responseError(let error):
                    return .responseError(error)
                    
                case .requestError(let error):
                    return .requestError(error)
                }
            }.eraseToAnyPublisher()
    }
}
