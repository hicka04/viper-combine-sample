//
//  AppPresenterTests.swift
//  ViperCombineSampleTests
//
//  Created by hicka04 on 2021/06/02.
//

@testable import ViperCombineSample
import Quick
import Nimble

final class AppPresenterTests: QuickSpec {
    override func spec() {
        var presenter: AppPresenter!
        var router: MockAppRouter!
        
        beforeEach {
            router = .init()
            presenter = .init(router: router)
        }
        
        describe("sceneWillConnectToSession") {
            beforeEach {
                presenter.sceneWillConnectToSession()
            }
            
            it("router.navigate called") {
                expect(router.navigateCallCount) == 1
            }
            
            it("destination is articleSearch") {
                expect(router.navigateCallArguments.first) == .artcileSearch
            }
        }
    }
}

extension AppPresenterTests {
    final class MockAppRouter: AppWireframe {
        var navigateCallCount: Int {
            navigateCallArguments.count
        }
        private(set) var navigateCallArguments: [AppDestination] = []
        func navigatie(to destination: AppDestination) {
            navigateCallArguments.append(destination)
        }
    }
}
