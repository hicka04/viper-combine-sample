//
//  AppPresenter.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/05/21.
//

import Foundation
import Combine

protocol AppPresentation: AnyObject {
    func sceneWillConnectToSession()
}

final class AppPresenter {
    private var cancellables: Set<AnyCancellable> = []
    private let sceneWillConnectToSessionSubject = PassthroughSubject<Void, Never>()
    private let destinationSubject = PassthroughSubject<AppDestination, Never>()
    
    init<Router: AppWireframe>(
        router: Router
    ) {
        destinationSubject
            .sink { destination in
                router.navigatie(to: destination)
            }.store(in: &cancellables)
        
        sceneWillConnectToSessionSubject
            .map { .artcileSearch }
            .subscribe(destinationSubject)
            .store(in: &cancellables)
    }
}

extension AppPresenter: AppPresentation {
    func sceneWillConnectToSession() {
        sceneWillConnectToSessionSubject.send()
    }
}
