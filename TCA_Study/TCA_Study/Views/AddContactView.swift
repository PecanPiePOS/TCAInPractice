//
//  AddContactView.swift
//  TCA_Study
//
//  Created by KYUBO A. SHIM on 1/12/24.
//

import SwiftUI

import ComposableArchitecture

struct AddContactView: View {
    
    let store: StoreOf<AddContactsFeature>
    @ObservedObject var viewStore: ViewStoreOf<AddContactsFeature>
    
    init(store: StoreOf<AddContactsFeature>) {
        self.store = store
        self.viewStore = ViewStore(self.store, observe: { $0 })
    }
    
    var body: some View {
        Form {
            TextField("Name", text: viewStore.binding(get: \.contact.name, send: { .setName($0) }))
            Button("Save") {
                viewStore.send(.saveButtonDidTap)
            }
            .foregroundStyle(.green)
        }
        .toolbar {
            ToolbarItem {
                Button("Cancel") {
                    viewStore.send(.cancelButtonDidtap)
                }
                .foregroundStyle(.orange)
            }
        }
    }
}
