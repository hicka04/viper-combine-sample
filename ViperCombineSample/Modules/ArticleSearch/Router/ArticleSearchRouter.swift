//
//  ArticleSearchRouter.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/05/21.
//

import UIKit
import Combine

enum ArticleSearchDestination: Equatable {
    case articleDetail(_ article: ArticleModel)
}

protocol ArticleSearchWireframe: Wireframe where Destination == ArticleSearchDestination {}

final class ArticleSearchRouter: ArticleSearchWireframe {
    private var cancellables: Set<AnyCancellable> = []
    let navigationSubject = PassthroughSubject<ArticleSearchDestination, Never>()
    
    private init(viewController: UIViewController) {
        navigationSubject
            .sink { [unowned viewController] destination in
                switch destination {
                case .articleDetail(let article):
                    let articleDetailView = ArticleDetailRouter.assembleModules(article: article)
                    viewController.navigationController?.pushViewController(articleDetailView, animated: true)
                }
            }.store(in: &cancellables)
    }
    
    static func assembleModules() -> UIViewController {
        let view = ArticleSearchViewController()
        let router = ArticleSearchRouter(viewController: view)
        let qiitaDataStore = QiitaDataStore()
        let articleSearchInteractor = ArticleSearchInteractor(qiitaRepository: qiitaDataStore)
        let presenter = ArticleSearchPresenter(router: router, articleSearchInteractor: articleSearchInteractor)
        
        view.presenter = presenter
        
        return view
    }
}
