//
//  CounterView.swift
//  TCA_Study
//
//  Created by KYUBO A. SHIM on 12/28/23.
//

import SwiftUI

import ComposableArchitecture

extension CounterFeature.State: Equatable {}

struct CounterView: View {
    let store: StoreOf<CounterFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                Color.black
                
                VStack {
                    Text("\(viewStore.count)")
                        .font(.largeTitle)
                        .frame(width: 50)
                        .padding()
                        .foregroundStyle(.white)
                        .background(Color.orange.opacity(1.0))
                        .cornerRadius(10)
                    HStack {
                        Button("-") {
                            viewStore.send(.decrementButtonDidTap)
                        }
                        .font(.largeTitle)
                        .frame(width: 20)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(10)
                        
                        
                        Button("+") {
                            viewStore.send(.incrementButtonDidTap)
                        }
                        .font(.largeTitle)
                        .frame(width: 20)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(10)
                    }
                }
            }
            .ignoresSafeArea()
        }
    }
}
