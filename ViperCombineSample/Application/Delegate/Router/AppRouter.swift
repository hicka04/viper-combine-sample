//
//  AppRouter.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/05/21.
//

import UIKit

enum AppDestination {
    case artcileSearch
}

protocol AppWireframe: Wireframe where Destination == AppDestination {}

final class AppRouter {
    private let window: UIWindow
    
    private init(window: UIWindow) {
        self.window = window
    }
    
    static func assembleModules(windowScene: UIWindowScene) -> AppPresentation {
        let router = AppRouter(window: UIWindow(windowScene: windowScene))
        let presenter = AppPresenter(router: router)
        
        return presenter
    }
}

extension AppRouter: AppWireframe {
    func navigatie(to destination: AppDestination) {
        window.rootViewController = UINavigationController(rootViewController: ArticleSearchRouter.assembleModules())
        window.makeKeyAndVisible()
    }
}
