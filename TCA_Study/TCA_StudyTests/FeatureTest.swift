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
    
    /// 이제 제일 중요한, Network Request 를 Test 해볼건데
    /// side effcct 케이스 중 가장 흔한 케이스라고 할 수 있다. (서버가 유저의 데이터를 가지고 있기 때문에)
    /// Testing 하는 난이도가 높다.
    /// 1. 네트워크 속도가 느릴 수 있다.
    /// 2. 서버에서 어떤 값이 내려올지 정확히 예측할 수 없기 때문이다.
    func testNetworkRequest() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.networkData.fetch = { "\($0) is a good number." }
        }
        
        /// 1. fact 버튼을 누른다.
        /// 2. isLoading 에 반영이 된다.
        /// 3. 시간이 흐른 뒤, 데이터가 시스템 내부로 들어온다.
        await store.send(.factButtonDidTap) {
            $0.isLoading = true
        }
        
        await store.receive(\.factResponse) {
            $0.isLoading = false
            $0.fact = "0 is a good number."
        }
    }
    
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
