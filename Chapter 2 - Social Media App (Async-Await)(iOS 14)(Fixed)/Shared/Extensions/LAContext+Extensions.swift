//
//  LAContext+Extensions.swift
//  Chapter 2 - Social Media App (iOS)
//
//  Created by Andy Ibanez on 5/11/22.
//

import Foundation
import LocalAuthentication

extension LAContext {
    @available(iOS, introduced: 13, deprecated: 15, message: "This method is no longer necessary. Use the API available in iOS 15.")
    func evaluatePolicy(_ policy: LAPolicy, localizedReason: String) async throws -> Bool {
        try await withCheckedThrowingContinuation({ continuation in
            self.evaluatePolicy(policy, localizedReason: localizedReason) { success, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: success)
                }
            }
        })
    }
}
