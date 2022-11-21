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
    
    func requestPermissions(completionHandler: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        store.requestAuthorization(toShare: nil, read: dataSets, completion: completionHandler)
    }
    
    func requestData(
        completionHandler: @escaping (_ sampleQuery: HKSampleQuery, _ samples: [HKSample]?, _ error: Error?) -> Void
    ) {
        let descriptors = dataSets.map {
            HKQueryDescriptor(
                sampleType: $0,
                predicate: setUpQueryPredicate()
            )
            
        }
        let quantityQuery = HKSampleQuery(
            queryDescriptors: descriptors,
            limit: privateSetLimit,
            resultsHandler: completionHandler
        )
        store.execute(quantityQuery)
    }
    
    private func setUpQueryPredicate() -> NSPredicate {
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
