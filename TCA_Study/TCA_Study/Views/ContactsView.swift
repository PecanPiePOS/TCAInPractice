//
//  ContactsView.swift
//  TCA_Study
//
//  Created by KYUBO A. SHIM on 1/12/24.
//

import SwiftUI

import ComposableArchitecture

struct ContactsView: View {
    let store: StoreOf<ContactsFeature>
    @ObservedObject var viewStore: ViewStoreOf<ContactsFeature>
    
    init(store: StoreOf<ContactsFeature>) {
        self.store = store
        self.viewStore = ViewStore(self.store, observe: { $0 })
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewStore.state.contacts) { contact in
                    HStack {
                        Text(contact.name)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.gray)
                    }
                }
            }
            .navigationTitle("Contacts")
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        viewStore.send(.addButtonDidTap)
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .tint(.purple)
                    })
                }
            }
        }
        .sheet(store: self.store.scope(
            state: \.$addContact,
            action: \.addContact)
        ) { addContactStore in
            NavigationStack {
                AddContactView(store: addContactStore)
            }
        }
    }
}

#Preview {
    ContactsView(store: Store(
        initialState: ContactsFeature.State(
            contacts: [
                ContactModel(id: UUID(), name: "Neymar"),
                ContactModel(id: UUID(), name: "Dele"),
                ContactModel(id: UUID(), name: "Son"),
                ContactModel(id: UUID(), name: "Romero")
            ]
        )) {
                ContactsFeature()
            })
}


