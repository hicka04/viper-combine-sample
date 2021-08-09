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
        paginationPublisher(request: ArticleSearchRequest(keyword: keyword, page: 1, pageSize: 20), session: session)
            .map { $0.items.map { $0.translate() } }
            .eraseToAnyPublisher()
    }
}
