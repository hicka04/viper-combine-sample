//
//  AppPresenter.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/05/21.
//

import Foundation
import Combine

enum AppEvent {
    case sceneWillConnectToSession
}

protocol AppPresentation: AnyObject {
    var appEventSubject: PassthroughSubject<AppEvent, Never> { get }
}

final class AppPresenter: AppPresentation {
    private var cancellables: Set<AnyCancellable> = []
    let appEventSubject = PassthroughSubject<AppEvent, Never>()
    
    init<Router: AppWireframe>(
        router: Router
    ) {
        appEventSubject
            .map { appEvent -> AppDestination in
                switch appEvent {
                case .sceneWillConnectToSession:
                    return .main
                }
            }.sink { destination in
                router.navigationSubject.send(destination)
            }.store(in: &cancellables)
    }
}
