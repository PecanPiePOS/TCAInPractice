//
//  UpgradedContactFeature.swift
//  TCA_Study
//
//  Created by KYUBO A. SHIM on 1/16/24.
//

import Foundation

import ComposableArchitecture

/// 새로운 Reducer 를 기존의 Feature 에서 만들자.
extension ContactsFeature {
    
    @Reducer
    struct Destination {
        enum State: Equatable {
            case addContact(AddContactsFeature.State)
            case alert(AlertState<ContactsFeature.Action.Alert>)
        }
        
        enum Action {
            case addContact(AddContactsFeature.Action)
            case alert(ContactsFeature.Action.Alert)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: \.addContact, action: \.addContact) {
                AddContactsFeature()
            }
        }
    }
}
