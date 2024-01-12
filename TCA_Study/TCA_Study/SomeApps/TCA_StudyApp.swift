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
    static let store = Store(
        initialState: ContactsFeature.State(
            contacts: [
                ContactModel(id: UUID(), name: "Neymar"),
                ContactModel(id: UUID(), name: "Dele"),
                ContactModel(id: UUID(), name: "Son"),
                ContactModel(id: UUID(), name: "Romero")
            ]
        )) {
            ContactsFeature()
                ._printChanges()
        }
    
    var body: some Scene {
        WindowGroup {
            ContactsView(store: TCA_StudyApp.store)
        }
    }
}
