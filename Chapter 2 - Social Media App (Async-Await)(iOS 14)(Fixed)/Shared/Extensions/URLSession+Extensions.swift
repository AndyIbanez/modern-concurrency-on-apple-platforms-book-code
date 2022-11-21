//
//  URLSession+Extensions.swift
//  Chapter 2 - Social Media App (iOS)
//
//  Created by Andy Ibanez on 5/11/22.
//

import Foundation

extension URLSession {
    @available(iOS, introduced: 13, deprecated: 15, message: "This method is no longer necessary. Use the API available in iOS 15.")
    func data(from url: URL) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation({ continuation in
            self.dataTask(with: url) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: (data!, response!))
                }
            }
            .resume()
        })
    }
}
