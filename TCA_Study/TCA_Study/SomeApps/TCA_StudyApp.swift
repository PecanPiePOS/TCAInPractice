//
//  TCA_StudyApp.swift
//  TCA_Study
//
//  Created by KYUBO A. SHIM on 12/27/23.
//

import SwiftUI
import SwiftData

import ComposableArchitecture

@main
struct TCA_StudyApp: App {
    static let store = Store(initialState: CounterFeature.State()) {
        CounterFeature()
            ._printChanges()
    }

    var body: some Scene {
        WindowGroup {
            CounterView(
                store: TCA_StudyApp.store
            )
        }
    }
}
