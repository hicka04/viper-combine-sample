//
//  ArticleSearchPresenter.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/05/21.
//

import Foundation
import Combine
import CombineSchedulers

enum ArticleSearchViewEvent {
    case viewDidLoad
}

final class ArticleSearchPresenter: Presentation {
    private var cancellables: Set<AnyCancellable> = []
    let viewEventSubject = PassthroughSubject<ArticleSearchViewEvent, Never>()
    
    @Published var articles: [ArticleModel] = []
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
                case .viewDidLoad:
                    searchKeywordSubject.send("Swift")
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
                    self?.articles = articles
                    
                case .failure(let error):
                    self?.articleSearchError = error
                }
            }.store(in: &cancellables)
    }
}
