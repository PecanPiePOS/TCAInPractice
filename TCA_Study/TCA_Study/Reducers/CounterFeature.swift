//
//  CounterFeature.swift
//  TCA_Study
//
//  Created by KYUBO A. SHIM on 12/27/23.
//

import Foundation
import SwiftUI

import ComposableArchitecture

@Reducer
struct CounterFeature: Reducer {
    public struct State: Equatable {
        var count = 0
    }
    
    enum Action {
        case decrementButtonDidTap
        case incrementButtonDidTap
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .decrementButtonDidTap:
                state.count -= 1
                return .none
            case .incrementButtonDidTap:
                state.count += 1
                return .none
            }
        }
    }
}
