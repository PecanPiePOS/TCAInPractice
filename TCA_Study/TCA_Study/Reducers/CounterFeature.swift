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
        var isLoading = false
        var fact: String?
    }
    
    enum Action {
        case decrementButtonDidTap
        case incrementButtonDidTap
        case factButtonDidTap
        case factResponse(String)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .decrementButtonDidTap:
                state.count -= 1
                state.fact = nil
                return .none
            case .incrementButtonDidTap:
                state.count += 1
                state.fact = nil
                return .none
            case .factButtonDidTap:
                state.fact = nil
                state.isLoading = true
                
                return .run { [count = state.count] send in
                    let (data, _) = try await URLSession.shared.data(from: URL(string: "http://numbersapi.com/\(count)")!)
                    let fact = String(decoding: data, as: UTF8.self)
                    await send(.factResponse(fact))
                } catch: { error, send in
                    print(error)
                }
            case let .factResponse(fact):
                state.fact = fact
                state.isLoading = false
                return .none
            }
        }
    }
}
