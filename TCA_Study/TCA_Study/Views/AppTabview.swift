//
//  AppTabview.swift
//  TCA_Study
//
//  Created by KYUBO A. SHIM on 1/6/24.
//

import SwiftUI

import ComposableArchitecture

/// Combine Added Test
struct AppTabview: View {
    
    /// 하나의 Store 로 뷰의 모든걸 책임지는 Reducer 를 적용했다.
    let store: StoreOf<AppFeature>
    
    var body: some View {
        NavigationStack {
            TabView {
                CounterView(store: store.scope(state: \.tab1, action: \.tab1))
                    .tabItem { Image(systemName: "dial.low") }
                
                CounterView(store: store.scope(state: \.tab2, action: \.tab2))
                    .tabItem { Image(systemName: "slider.horizontal.2.square") }
            }
            .tint(.red)
        }
        .navigationTitle("Features")
        .foregroundStyle(.white)
    }
}

#Preview {
    AppTabview(store: Store(initialState: AppFeature.State(), reducer: {
        AppFeature()
    }))
}
