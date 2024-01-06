//
//  FeatureTest.swift
//  TCA_StudyTests
//
//  Created by KYUBO A. SHIM on 1/4/24.
//

import XCTest

import ComposableArchitecture
@testable import TCA_Study

@MainActor
final class CounterFeatureTests: XCTestCase {
    
    func testTimer() async {
        let clock = TestClock()
        
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.continuousClock = clock
        }
        
        await store.send(.toggleTimerButtonDidTap) {
            $0.isTimerRunning = true
        }
        
        await clock.advance(by: .seconds(2))
        await store.receive(\.timerTick) {
            $0.count = 1
        }
        
        await store.send(.toggleTimerButtonDidTap) {
            $0.isTimerRunning = false
        }
    }
    
    func testCounter() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        }
        
        /// send 가 await 인 이유는 TestStore 에서의 send 는 async 이기 때문이다.
        await store.send(.incrementButtonDidTap) {
            $0.count = 1
        }
        
        /// 이때, absolute mutation 으로 선언하는 것이 훨씬 좋다.
        /// 예를 들어, 예시와 같이 state.count = 0 이 맞다.
        /// 테스트를 하는 사람이 이 구체적인 값을 알고 있다는 것을 암시하니깐 말이다.
        /// state.count += 1 은 action 이 일어난 뒤의 값을 모르는 것이니깐 말이다.
        await store.send(.decrementButtonDidTap) {
            $0.count = 0
        }
        
        await store.send(.decrementButtonDidTap) {
            $0.count = -1
        }
    }
}
