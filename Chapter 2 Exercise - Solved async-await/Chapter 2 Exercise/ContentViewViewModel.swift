//
//  ContentViewViewModel.swift
//  Chapter 2 Exercise
//
//  Created by Andy Ibanez on 5/26/22.
//

import Foundation
import HealthKit

@MainActor
class ContentViewViewModel: ObservableObject {
    @Published private(set) var totalSteps: Double = 0
    @Published private(set) var totalFlightsClimbed: Double = 0
    @Published private(set) var totalActiveCalsBurned: Double = 0
    @Published private(set) var error: Error?
    
    var healthManager: HealthManager?
    
    func requestPermissionAndPopulate() {
        Task {
            guard let healthManager = healthManager else { return }
            // The HealthKit API opts to return an error if requesting authorization is not successful.
            // It won't return a bool value at all, but if an error is thrown, nothing underneath the
            // next line will execute.
            try await healthManager.requestPermissions()
            let data = try await healthManager.requestData()
            self.totalSteps = getData(from: data, for: .stepCount, unit: .count())
            self.totalActiveCalsBurned = getData(from: data, for: .activeEnergyBurned, unit: .kilocalorie())
            self.totalFlightsClimbed = getData(from: data, for: .flightsClimbed, unit: .count())
        }
    }
    
    private func getData(from samples: [HKSample], for type: HKQuantityTypeIdentifier, unit: HKUnit) -> Double {
        samples
            .filter { $0.sampleType == .quantityType(forIdentifier: type) }
            .compactMap { $0 as? HKCumulativeQuantitySample }
            .reduce(0) { $0 + $1.sumQuantity.doubleValue(for: unit) }
    }
}
