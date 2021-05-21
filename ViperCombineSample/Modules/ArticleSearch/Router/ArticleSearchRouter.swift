//
//  ArticleSearchRouter.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/05/21.
//

import UIKit

enum ArticleSearchDestination {
    
}

protocol ArticleSearchWireframe: Wireframe where Destination == ArticleSearchDestination {}

final class ArticleSearchRouter {
    private unowned let viewController: UIViewController
    
    private init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    static func assembleModules() -> UIViewController {
        let view = ArticleSearchViewController()
        let router = ArticleSearchRouter(viewController: view)
        let presenter = ArticleSearchPresenter(router: router)
        
        view.presenter = presenter
        
        return view
    }
}

extension ArticleSearchRouter: ArticleSearchWireframe {
    func navigatie(to destination: ArticleSearchDestination) {
        
    }
}
