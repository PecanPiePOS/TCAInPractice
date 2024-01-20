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
        var contacts: IdentifiedArrayOf<ContactModel> = []
        @PresentationState var destination: Destination.State?
    }
    
    enum Action {
        case addButtonDidTap
        case addContact(PresentationAction<AddContactsFeature.Action>)
        case deleteButtonDidTap(id: ContactModel.ID)
        case alert(PresentationAction<Alert>)
        
        case destination(PresentationAction<Destination.Action>)
        enum Alert: Equatable {
            case confirmDeletion(id: ContactModel.ID)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonDidTap:
                state.destination = .addContact(
                    AddContactsFeature.State(contact: ContactModel(id: UUID(), name: ""))
                )
                return .none
            case let .addContact(.presented(.delegate(.saveContact(contact)))):
                state.contacts.append(contact)
                return .none
            case .addContact:
                return .none
            case let .alert(.presented(.confirmDeletion(id: id))):
                state.contacts.remove(id: id)
                return .none
            case .alert:
                return .none
            case let .destination(.presented(.addContact(.delegate(.saveContact(contact))))):
                state.contacts.append(contact)
                return .none
            case let .destination(.presented(.alert(.confirmDeletion(id: id)))):
                state.contacts.remove(id: id)
                return .none
            case .destination:
                return .none
            case let .deleteButtonDidTap(id: id):
                state.destination = .alert(
                    AlertState {
                        TextState(verbatim: "Are you sure?")
                    } actions: {
                        ButtonState(role: .destructive, action: .confirmDeletion(id: id)) {
                            TextState("Delete")
                        }
                    }
                
                )
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination()
        }
//        .ifLet(\.$addContact, action: \.addContact) {
//            AddContactsFeature()
//        }
//        .ifLet(\.$alert, action: \.alert)
    }
}
