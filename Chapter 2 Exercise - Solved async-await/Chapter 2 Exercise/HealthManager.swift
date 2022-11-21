//
//  HealthManager.swift
//  Chapter 2 Exercise
//
//  Created by Andy Ibanez on 5/26/22.
//

import Foundation
import HealthKit

class HealthManager: ObservableObject {
    private let store: HKHealthStore
    private let dataSets: Set<HKQuantityType> = [
        .quantityType(forIdentifier: .stepCount)!,
        .quantityType(forIdentifier: .flightsClimbed)!,
        .quantityType(forIdentifier: .activeEnergyBurned)!
    ]
    private let privateSetLimit = 300
    
    var healthKitAvailable: Bool { HKHealthStore.isHealthDataAvailable() }
    
    init(store: HKHealthStore) {
        self.store = store
    }
    
    func requestPermissions() async throws {
        try await store.requestAuthorization(toShare: [], read: dataSets)
    }
    
    func requestData() async throws -> [HKSample] {
        let descriptor = HKSampleQueryDescriptor(
            predicates: setUpQueryPredicates(),
            sortDescriptors: []
        )
        let results = try await descriptor.result(for: store)
        return results
    }
    
    private func setUpQueryPredicates() -> [HKSamplePredicate<HKSample>] {
        let predicates = dataSets.map {
            HKSamplePredicate.sample(type: $0, predicate: setUpDatePredicate())
        }
        return predicates
    }
    
    private func setUpDatePredicate() -> NSPredicate {
        // Samples within a week.
        let now = Date.now
        let weekComponents = DateComponents(day: -7)
        let lastWeek = Calendar.current.date(
            byAdding: weekComponents,
            to: now,
            wrappingComponents: false
        )
        let predicate = HKQuery.predicateForSamples(withStart: lastWeek, end: now)
        return predicate
    }
}
