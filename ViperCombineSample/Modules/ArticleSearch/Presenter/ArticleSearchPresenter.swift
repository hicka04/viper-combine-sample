//
//  ArticleSearchPresenter.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/05/21.
//

import Foundation
import Combine
import CombineSchedulers
import OrderedCollections

enum ArticleSearchViewEvent {
    case viewDidLoad
    case refreshControlValueChanged
    case didSelect(article: ArticleModel)
}

final class ArticleSearchPresenter: Presentation {
    private var cancellables: Set<AnyCancellable> = []
    let viewEventSubject = PassthroughSubject<ArticleSearchViewEvent, Never>()
    
    @Published var articles: OrderedSet<ArticleModel> = []
    @Published var articleSearchError: ArticleSearchError?
    
    init<
        Router: ArticleSearchWireframe,
        ArticleSearchInteractor: ArticleSearchUsecase
    >(
        mainScheduler: AnySchedulerOf<DispatchQueue> = .main,
        router: Router,
        articleSearchInteractor: ArticleSearchInteractor
    ) {
        let searchKeywordSubject = PassthroughSubject<String, Never>()
        
        viewEventSubject
            .sink { event in
                switch event {
                case .viewDidLoad, .refreshControlValueChanged:
                    searchKeywordSubject.send("Swift")
                    
                case .didSelect(let article):
                    router.navigationSubject.send(.articleDetail(article))
                }
            }.store(in: &cancellables)
        
        searchKeywordSubject
            .flatMap { searchKeyword in
                articleSearchInteractor
                    .execute(searchKeyword)
                    .convertToResultPublisher()
            }.receive(on: mainScheduler)
            .sink { [weak self] result in
                switch result {
                case .success(let articles):
                    self?.articles.elements = articles
                    
                case .failure(let error):
                    self?.articleSearchError = error
                }
            }.store(in: &cancellables)
    }
}
