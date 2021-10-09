//
//  AppPresenterTests.swift
//  ViperCombineSampleTests
//
//  Created by hicka04 on 2021/06/02.
//

@testable import ViperCombineSample
import Quick
import Nimble
import Combine
import CombineSchedulers

final class AppPresenterTests: QuickSpec {
    override func spec() {
        var cancellables: Set<AnyCancellable> = []
        var testScheduler: TestSchedulerOf<DispatchQueue>!
        var navigationOutputs: [AppDestination] = []
        
        var presenter: AppPresenter!
        var router: MockAppRouter!
        
        beforeEach {
            testScheduler = DispatchQueue.test
            
            router = .init()
            presenter = .init(router: router)
            
            router.navigationSubject.sink { navigationOutputs.append($0) }.store(in: &cancellables)
        }
        
        afterEach {
            cancellables = []
        }
        
        describe("sceneWillConnectToSession") {
            beforeEach {
                testScheduler.schedule {
                    presenter.appEventSubject.send(.sceneWillConnectToSession)
                }
                testScheduler.advance()
            }
            
            it("destination is main") {
                expect(navigationOutputs) == [
                    .main
                ]
            }
        }
    }
}

extension AppPresenterTests {
    final class MockAppRouter: AppWireframe {
        let navigationSubject = PassthroughSubject<AppDestination, Never>()
    }
}
