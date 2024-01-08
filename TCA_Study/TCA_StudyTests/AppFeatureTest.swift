//
//  AppFeatureTest.swift
//  TCA_StudyTests
//
//  Created by KYUBO A. SHIM on 1/8/24.
//

import XCTest

import ComposableArchitecture
@testable import TCA_Study

@MainActor
final class AppFeatureTest: XCTestCase {
    
    func testIncrementInFirstTab() async {
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        }
        
        await store.send(.tab1(.incrementButtonDidTap)) {
            $0.tab1.count = 1
        }
    }
    
}
