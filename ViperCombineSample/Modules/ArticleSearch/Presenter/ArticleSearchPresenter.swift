//
//  ArticleSearchPresenter.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/05/21.
//

import Foundation
import Combine

protocol ArticleSearchPresentation: AnyObject {
    var articlesSubject: CurrentValueSubject<[ArticleModel], Never> { get }
    
    func viewDidLoad()
}

final class ArticleSearchPresenter {
    private var cancellables: Set<AnyCancellable> = []
    private let viewDidLoadSubject = PassthroughSubject<Void, Never>()
    
    var articlesSubject = CurrentValueSubject<[ArticleModel], Never>([])
    
    init<
        Router: ArticleSearchWireframe,
        ArticleSearchInteractor: ArticleSearchUsecase
    >(
        router: Router,
        articleSearchInteractor: ArticleSearchInteractor
    ) {
        viewDidLoadSubject
            .flatMap {
                articleSearchInteractor
                    .execute("Swift")
                    .catch { _ in
                        Empty()
                    }
            }
            .subscribe(articlesSubject)
            .store(in: &cancellables)
    }
}

extension ArticleSearchPresenter: ArticleSearchPresentation {
    func viewDidLoad() {
        viewDidLoadSubject.send()
    }
}
