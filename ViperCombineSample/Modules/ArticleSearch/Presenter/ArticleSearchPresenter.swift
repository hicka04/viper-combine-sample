//
//  ArticleSearchPresenter.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/05/21.
//

import Foundation
import Combine

enum ArticleSearchViewEvent {
    case viewDidLoad
}

protocol ArticleSearchPresentation: Presentation where ViewEvent == ArticleSearchViewEvent {
    var articles: [ArticleModel] { get }
    var articlesPublisher: Published<[ArticleModel]>.Publisher { get }
}

final class ArticleSearchPresenter: ArticleSearchPresentation {
    private var cancellables: Set<AnyCancellable> = []
    let viewEventSubject = PassthroughSubject<ArticleSearchViewEvent, Never>()
    
    @Published var articles: [ArticleModel] = []
    var articlesPublisher: Published<[ArticleModel]>.Publisher { $articles }

    @Published var articleSearchError: ArticleSearchError?
    
    init<
        Router: ArticleSearchWireframe,
        ArticleSearchInteractor: ArticleSearchUsecase
    >(
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
            .setFailureType(to: ArticleSearchError.self)
            .flatMap { searchKeyword in
                articleSearchInteractor.execute(searchKeyword)
            }.subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .catch { [weak self] error -> Empty<[ArticleModel], Never> in
                self?.articleSearchError = error
                return .init()
            }.sink { [weak self] articles in
                self?.articles = articles
            }.store(in: &cancellables)
    }
}
