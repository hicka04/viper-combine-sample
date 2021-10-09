//
//  MainRouter.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/10/09.
//

import UIKit
import Combine

enum MainDestination: Equatable {
}

protocol MainWireframe: Wireframe where Destination == MainDestination {}

final class MainRouter: MainWireframe {
    private var cancellables: Set<AnyCancellable> = []
    let navigationSubject = PassthroughSubject<MainDestination, Never>()
    
    private init(viewController: UIViewController) {
        navigationSubject
            .sink { [unowned viewController] destination in
            }.store(in: &cancellables)
    }
    
    static func assembleModules() -> UIViewController {
        let view: MainViewController = {
            let uikitView = UINavigationController(rootViewController: ArticleSearchRouter.assembleModules())
            uikitView.tabBarItem = .init(title: "UIKit", image: .init(systemName: "magnifyingglass"), selectedImage: nil)
            
            let swiftUIView = UINavigationController(rootViewController: ArticleSearchRouter.assembleModulesSwiftUI())
            swiftUIView.tabBarItem = .init(title: "SwiftUI", image: .init(systemName: "magnifyingglass"), selectedImage: nil)
            
            let view = MainViewController()
            view.viewControllers = [
                uikitView,
                swiftUIView
            ]
            
            return view
        }()
        let router = MainRouter(viewController: view)
        let presenter = MainPresenter(router: router)
        
        view.presenter = presenter
        
        return view
    }
}
