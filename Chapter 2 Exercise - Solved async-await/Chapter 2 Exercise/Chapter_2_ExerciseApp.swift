//
//  Chapter_2_ExerciseApp.swift
//  Chapter 2 Exercise
//
//  Created by Andy Ibanez on 5/26/22.
//

import SwiftUI
import HealthKit

fileprivate let healthManager = HealthManager(store: HKHealthStore())

@main
struct Chapter_2_ExerciseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(healthManager)
        }
    }
}
