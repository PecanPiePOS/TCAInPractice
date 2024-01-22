//
//  ContactFeatureTests.swift
//  TCA_StudyTests
//
//  Created by KYUBO A. SHIM on 1/21/24.
//

import XCTest

import ComposableArchitecture
@testable import TCA_Study

@MainActor
final class ContactFeatureTests: XCTestCase {
    
    func testAddFlow_NonExhaustive() async {
        let store = TestStore(initialState: ContactsFeature.State()) {
            ContactsFeature()
                ._printChanges()
        } withDependencies: {
            $0.uuid = .incrementing
        }
        store.exhaustivity = .off
        
        await store.send(.addButtonDidTap)
        await store.send(.destination(.presented(.addContact(.setName("Korean Guy")))))
        await store.send(.destination(.presented(.addContact(.saveButtonDidTap))))
        /// Next we want to assert that sometime after the user taps the “Save” button that the contact is added to the array and the child feature is dismissed. However, we cannot assert on that until all the actions have been received, and so we can do that by using skipReceivedActions(strict:file:line:).
        /// 즉, 이 메서드 이후로의 action 은 건너뛴다는거다.
        await store.skipReceivedActions()
        store.assert { state in
            state.contacts = [
                ContactModel(id: UUID(0), name: "Korean Guy")
            ]
            state.destination = nil
        }
    }
    
    func testDeleteFlow() async {
        let store = TestStore(initialState: ContactsFeature.State(
            contacts: [
                ContactModel(id: UUID(0), name: "Ayo"),
                ContactModel(id: UUID(1), name: "Byo")
            ]
        )) {
            ContactsFeature()
        }
                
        await store.send(.deleteButtonDidTap(id: UUID(0))) { state in
            state.destination = .alert(.deleteConfirmation(id: UUID(0)))
        }
        await store.send(.destination(.presented(.alert(.confirmDeletion(id: UUID(0)))))) { state in
            state.destination = nil
            state.contacts.remove(id: UUID(0))
        }
    }
    
    func testDeleFlow_NonExhaustive() async {
        let store = TestStore(initialState: ContactsFeature.State(
            contacts: [
                ContactModel(id: UUID(0), name: "Ayo"),
                ContactModel(id: UUID(1), name: "Byo")
            ]
        )) {
            ContactsFeature()
                ._printChanges()
        }
        store.exhaustivity = .off
        
        await store.send(.deleteButtonDidTap(id: UUID(1)))
        await store.send(.destination(.presented(.alert(.confirmDeletion(id: UUID(1))))))
//        await store.skipReceivedActions()
        store.assert { state in
            state.contacts = [
                ContactModel(id: UUID(0), name: "Ayo")
            ]
            state.destination = nil
        }
    }
}

//@MainActor
//final class ContactsFeatureTests: XCTestCase {
//    func testAddFlow() async {
//        let store = TestStore(initialState: ContactsFeature.State()) {
//            ContactsFeature()
//        } withDependencies: {
//            $0.uuid = .incrementing
//        }
//
//        await store.send(.addButtonDidTap) {
//            $0.destination = .addContact(
//                AddContactsFeature.State(
//                    contact: ContactModel(id: UUID(0), name: "")
//                )
//            )
//        }
//        await store.send(.destination(.presented(.addContact(.setName("Blob Jr."))))) {
//            $0.$destination[case: \.addContact]?.contact.name = "Blob Jr."
//        }
//        await store.send(.destination(.presented(.addContact(.saveButtonDidTap))))
//        await store.receive(
//            \.destination.addContact.delegate.saveContact,
//             ContactModel(id: UUID(0), name: "Blob Jr.")
//        ) {
//            $0.contacts = [
//                ContactModel(id: UUID(0), name: "Blob Jr.")
//            ]
//        }
//        await store.receive(\.destination.dismiss) {
//            $0.destination = nil
//        }
//    }
//}
