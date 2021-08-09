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
    case didSelect(article: ArticleModel)
    case willReachLatestCell
}

final class ArticleSearchPresenter: Presentation {
    private var cancellables: Set<AnyCancellable> = []
    let viewEventSubject = PassthroughSubject<ArticleSearchViewEvent, Never>()
    
    private var articleSearchSubscription: Subscription?
    
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
                    
                case .willReachLatestCell:
                    self.subscription?.request(.max(1))
                    
                case .didSelect(let article):
                    router.navigationSubject.send(.articleDetail(article))
                }
            }.store(in: &cancellables)
        
        searchKeywordSubject
            .setFailureType(to: ArticleSearchError.self)
            .flatMap { searchKeyword in
                articleSearchInteractor
                    .execute(searchKeyword)
            }.receive(on: mainScheduler)
            .subscribe(self)
    }
}

extension ArticleSearchPresenter: Subscriber {
    typealias Input = [ArticleModel]
    typealias Failure = ArticleSearchInteractor.Failure
    
    func receive(subscription: Subscription) {
        self.articleSearchSubscription = subscription
        subscription.request(.max(1))
    }
    
    func receive(_ input: [ArticleModel]) -> Subscribers.Demand {
        self.articles += input
        
        return .max(1)
    }
    
    func receive(completion: Subscribers.Completion<ArticleSearchInteractor.Failure>) {
        switch completion {
        case .failure(let error):
            self.articleSearchError = error
        
        case .finished:
            articleSearchSubscription?.cancel()
            articleSearchSubscription = nil
        }
    }
}
