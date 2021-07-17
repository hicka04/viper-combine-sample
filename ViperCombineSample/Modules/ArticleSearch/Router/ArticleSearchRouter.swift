//
//  ArticleSearchRouter.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/05/21.
//

import UIKit
import Combine

enum ArticleSearchDestination {
    
}

protocol ArticleSearchWireframe: Wireframe where Destination == ArticleSearchDestination {}

final class ArticleSearchRouter: ArticleSearchWireframe {
    private var cancellables: Set<AnyCancellable> = []
    let navigationSubject = PassthroughSubject<ArticleSearchDestination, Never>()
    
    private init(viewController: UIViewController) {
        navigationSubject
            .sink { [unowned viewController] destination in
                switch destination {
                
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
