//
//  MainPresenter.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/10/09.
//

import Foundation
import Combine

enum MainViewEvent {
}

final class MainPresenter: Presentation {
    private var cancellables: Set<AnyCancellable> = []
    let viewEventSubject = PassthroughSubject<ArticleSearchViewEvent, Never>()
    
    init<Router: MainWireframe>(router: Router) {
    }
}
