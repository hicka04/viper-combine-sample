//
//  ArticleDetailRouter.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/07/18.
//

import UIKit
import Combine

enum ArticleDetailDestination {
}

protocol ArticleDetailWireframe: Wireframe where Destination == ArticleDetailDestination {}

final class ArticleDetailRouter: ArticleDetailWireframe {
    private var cancellables: Set<AnyCancellable> = []
    let navigationSubject = PassthroughSubject<ArticleDetailDestination, Never>()
    
    private init(viewController: UIViewController) {
        navigationSubject
            .sink { [unowned viewController] destination in
                switch destination {
                
                }
            }.store(in: &cancellables)
    }
    
    static func assembleModules(article: ArticleModel) -> UIViewController {
        let view = ArticleDetailViewController()
        let router = ArticleDetailRouter(viewController: view)
        let presenter = ArticleDetailPresenter(router: router, article: article)
        
        view.presenter = presenter
        
        return view
    }
}
