//
//  LoadingStatus.swift
//  Chapter 2 - Social Media App (iOS)
//
//  Created by Andy Ibanez on 4/18/22.
//

import Foundation

enum LoadingStatus {
    case loading
    case idle
    case error(_ error: Error)
    
    var error: Error? {
        switch self {
        case .error(let error): return error
        default: return nil
        }
    }
}
