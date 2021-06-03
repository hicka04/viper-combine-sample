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
    let viewEventSubject = PassthroughSubject<ArticleSearchViewEvent, Never>()
    
    private var cancellables: Set<AnyCancellable> = []
    private let searchKeywordSubject = PassthroughSubject<String, Never>()
    
    @Published var articles: [ArticleModel] = []
    var articlesPublisher: Published<[ArticleModel]>.Publisher { $articles }
    
    init<
        Router: ArticleSearchWireframe,
        ArticleSearchInteractor: ArticleSearchUsecase
    >(
        router: Router,
        articleSearchInteractor: ArticleSearchInteractor
    ) {
        viewEventSubject
            .sink { event in
                switch event {
                case .viewDidLoad:
                    self.searchKeywordSubject.send("Swift")
                }
            }.store(in: &cancellables)
        
        searchKeywordSubject
            .flatMap { searchKeyword in
                articleSearchInteractor
                    .execute(searchKeyword)
                    .catch { _ in
                        Empty()
                    }
            }.assign(to: \.articles, on: self)
            .store(in: &cancellables)
    }
}
