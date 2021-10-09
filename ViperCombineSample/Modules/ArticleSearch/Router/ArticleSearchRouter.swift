//
//  ArticleSearchRouter.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/05/21.
//

import UIKit
import SwiftUI
import Combine

enum ArticleSearchDestination: Equatable {
    case articleDetail(_ article: ArticleModel)
}

protocol ArticleSearchWireframe: Wireframe where Destination == ArticleSearchDestination {}

final class ArticleSearchRouter: ArticleSearchWireframe {
    private var cancellables: Set<AnyCancellable> = []
    fileprivate weak var viewController: UIViewController?
    let navigationSubject = PassthroughSubject<ArticleSearchDestination, Never>()
    
    private init() {
        navigationSubject
            .sink { destination in
                switch destination {
                case .articleDetail(let article):
                    let articleDetailView = ArticleDetailRouter.assembleModules(article: article)
                    self.viewController?.navigationController?.pushViewController(articleDetailView, animated: true)
                }
            }.store(in: &cancellables)
    }
    
    static func assembleModules() -> UIViewController {
        let router = ArticleSearchRouter()
        let qiitaDataStore = QiitaDataStore()
        let articleSearchInteractor = ArticleSearchInteractor(qiitaRepository: qiitaDataStore)
        let presenter = ArticleSearchPresenter(router: router, articleSearchInteractor: articleSearchInteractor)
        let view = ArticleSearchViewController(presenter: presenter)
        
        router.viewController = view
        
        return view
    }
    
    static func assembleModulesSwiftUI() -> UIViewController {
        let router = ArticleSearchRouter()
        let qiitaDataStore = QiitaDataStore()
        let articleSearchInteractor = ArticleSearchInteractor(qiitaRepository: qiitaDataStore)
        let presenter = ArticleSearchPresenter(router: router, articleSearchInteractor: articleSearchInteractor)
        let view = UIHostingController(rootView: ArticleSearchView(presenter: presenter))
        
        router.viewController = view
        
        return view
    }
}
