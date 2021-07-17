//
//  AppRouter.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/05/21.
//

import UIKit
import Combine

enum AppDestination {
    case artcileSearch
}

protocol AppWireframe: AnyObject {
    var navigationSubject: PassthroughSubject<AppDestination, Never>  { get }
}

final class AppRouter: AppWireframe {
    private var cancellables: Set<AnyCancellable> = []
    let navigationSubject = PassthroughSubject<AppDestination, Never>()
    
    private init(window: UIWindow) {
        navigationSubject
            .sink { destination in
                switch destination {
                case .artcileSearch:
                    window.rootViewController = UINavigationController(rootViewController: ArticleSearchRouter.assembleModules())
                    window.makeKeyAndVisible()
                }
            }.store(in: &cancellables)
    }
    
    static func assembleModules(windowScene: UIWindowScene) -> AppPresentation {
        let router = AppRouter(window: UIWindow(windowScene: windowScene))
        let presenter = AppPresenter(router: router)
        
        return presenter
    }
}
