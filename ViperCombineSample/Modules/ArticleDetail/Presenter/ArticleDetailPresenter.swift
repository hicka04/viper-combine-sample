//
//  ArticleDetailPresenter.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/07/18.
//

import Foundation
import Combine
import CombineSchedulers

enum ArticleDetailViewEvent {
}

final class ArticleDetailPresenter: Presentation {
    private var cancellables: Set<AnyCancellable> = []
    let viewEventSubject = PassthroughSubject<ArticleDetailViewEvent, Never>()
    
    let article: ArticleModel
    
    init<Router: ArticleDetailWireframe>(router: Router, article: ArticleModel) {
        self.article = article
    }
}
