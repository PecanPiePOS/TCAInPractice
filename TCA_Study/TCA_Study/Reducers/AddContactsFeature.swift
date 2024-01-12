//
//  AddContactsFeature.swift
//  TCA_Study
//
//  Created by KYUBO A. SHIM on 1/12/24.
//

import Foundation

import ComposableArchitecture

@Reducer
struct AddContactsFeature {
    
    typealias PersonName = String
    @Dependency(\.dismiss) var dismiss
    
    struct State: Equatable {
        var contact: ContactModel
    }
    
    enum Action {
        case cancelButtonDidtap
        case saveButtonDidTap
        case setName(PersonName)
        
        case delegate(Delegate)
        enum Delegate: Equatable {
            case saveContact(ContactModel)
        }
    }
    
        var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .cancelButtonDidtap:
                return .run { _ in await self.dismiss() }
            case .saveButtonDidTap:
                return .run { [contact = state.contact] send in
                    await send(.delegate(.saveContact(contact)))
                    await self.dismiss()
                }
            case let .setName(name):
                state.contact.name = name
                return .none
            case .delegate:
                return .none
            }
        }
    }
}
