//
//  ContactsFeature.swift
//  TCA_Study
//
//  Created by KYUBO A. SHIM on 1/12/24.
//

import Foundation

import ComposableArchitecture

@Reducer
struct ContactsFeature {
    
    struct State: Equatable {
        @PresentationState var addContact: AddContactsFeature.State?
        var contacts: IdentifiedArrayOf<ContactModel> = []
    }
    
    enum Action {
        case addButtonDidTap
        case addContact(PresentationAction<AddContactsFeature.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonDidTap:
                state.addContact = AddContactsFeature.State(
                    contact: ContactModel(id: UUID(), name: "")
                )
                return .none
            case let .addContact(.presented(.delegate(.saveContact(contact)))):
                state.contacts.append(contact)
                return .none
            case .addContact:
                return .none
            }
        }
        .ifLet(\.$addContact, action: \.addContact) {
            AddContactsFeature()
        }
    }
}
