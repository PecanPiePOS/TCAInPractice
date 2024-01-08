//
//  NetworkClient.swift
//  TCA_Study
//
//  Created by KYUBO A. SHIM on 1/6/24.
//

import Foundation

import ComposableArchitecture

struct NetworkClient {
    var fetch: (Int) async throws -> String
}

extension NetworkClient: DependencyKey {
    static let liveValue = Self (
        fetch: { number in
            let (data, _) = try await URLSession.shared
                .data(from: URL(string: "http://numbersapi.com/\(number)")!)
            return String(decoding: data, as: UTF8.self)
        }
    )
}

extension DependencyValues {
    var networkData: NetworkClient {
        get { self[NetworkClient.self] }
        set { self[NetworkClient.self] = newValue }
    }
}
