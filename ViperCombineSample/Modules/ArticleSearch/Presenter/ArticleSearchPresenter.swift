//
//  ArticleSearchPresenter.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/05/21.
//

import Foundation
import Combine

protocol ArticleSearchPresentation: AnyObject {
    
}

final class ArticleSearchPresenter {
    init<Router: ArticleSearchWireframe>(
        router: Router
    ) {
        
    }
}

extension ArticleSearchPresenter: ArticleSearchPresentation {
    
}
