//
//  FeatureTest.swift
//  TCA_StudyTests
//
//  Created by KYUBO A. SHIM on 1/4/24.
//

import XCTest

import ComposableArchitecture

@MainActor
final class CounterFeatureTests: XCTestCase {
    
    func testCounter() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        }
        
        /// send 가 await 인 이유는 TestStore 에서의 send 는 async 이기 때문이다.
        await store.send(.incrementButtonDidTap)
        await store.send(.decrementButtonDidTap)
    }
}
