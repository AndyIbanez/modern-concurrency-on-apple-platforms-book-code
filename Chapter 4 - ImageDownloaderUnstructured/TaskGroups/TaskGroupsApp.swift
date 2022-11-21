//
//  TaskGroupsApp.swift
//  TaskGroups
//
//  Created by Andy Ibanez on 5/30/22.
//

import SwiftUI

@MainActor
fileprivate let imageManager = ImageManager()

@main
struct TaskGroupsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(imageManager)
        }
    }
}
