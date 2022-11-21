//
//  ForumAppApp.swift
//  ForumApp
//
//  Created by Andy Ibanez on 6/1/22.
//

import SwiftUI

fileprivate let api = ForumAPI(urlSession: URLSession.shared)

@main
struct ForumAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(api)
        }
    }
}
