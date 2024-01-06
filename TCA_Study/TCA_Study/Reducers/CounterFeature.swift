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
        var isTimerRunning = false
    }
    
    enum Action {
        case decrementButtonDidTap
        case incrementButtonDidTap
        case factButtonDidTap
        case toggleTimerButtonDidTap
        case timerTick
        case factResponse(String)
    }
    
    @Dependency(\.continuousClock) var clock
    
    enum CancelID { case timer }
    
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
                
            case .timerTick:
                state.count += 1
                state.fact = nil
                return .none
            case .toggleTimerButtonDidTap:
                state.isTimerRunning.toggle()
                if state.isTimerRunning != false {
                    return .run { send in
                        for await _ in self.clock.timer(interval: .seconds(2)) {
                            await send(.timerTick)
                        }
                    }
                    .cancellable(id: CancelID.timer)
                } else {
                    return .cancel(id: CancelID.timer)
                }
            }
        }
    }
}
