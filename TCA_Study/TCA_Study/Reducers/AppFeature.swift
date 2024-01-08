//
//  AppFeature.swift
//  TCA_Study
//
//  Created by KYUBO A. SHIM on 1/8/24.
//

import Foundation

import ComposableArchitecture

// 예시에서는 View 와 Reducer 를 한 파일에 담았지만, 나는 따로 처리한다.
/// 앱 단계의 기능을 담당하는 Feature 다.
@Reducer
struct AppFeature {
    
    struct State: Equatable {
        var tab1 = CounterFeature.State()
        var tab2 = CounterFeature.State()
    }
    
    /// 이렇게 함으로써 AppFeature 에서 각 Tab 의 Action 에 관여할 수 있다.
    enum Action {
        case tab1(CounterFeature.Action)
        case tab2(CounterFeature.Action)
    }
        
    var body: some ReducerOf<Self> {
        /// CounterFeature 를 AppFeature 에 compose 하기 위해서 Scope 라는 Reducer 를 사용한다.
        /// Scope: Embeds a child reducer in a parent domain.
        Scope(state: \.tab1, action: \.tab1) {
            CounterFeature()
        }
        Scope(state: \.tab2, action: \.tab2) {
            CounterFeature()
        }
        /// 이렇게 나눔으로써, AppFeature 는 3개의 독립적인 feature 를 가지게 된다.
        Reduce { state, action in
            
            return .none
        }
    }
}
