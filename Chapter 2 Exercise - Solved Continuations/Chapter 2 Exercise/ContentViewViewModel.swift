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
            try await healthManager.requestPermissions()
            let samples = try await healthManager.requestData()
            self.totalSteps = getData(from: samples, for: .stepCount, unit: .count())
            self.totalFlightsClimbed = getData(from: samples, for: .flightsClimbed, unit: .count())
            self.totalActiveCalsBurned = getData(from: samples, for: .activeEnergyBurned, unit: .kilocalorie())
        }
    }
    
    private func getData(from samples: [HKSample], for type: HKQuantityTypeIdentifier, unit: HKUnit) -> Double {
        samples
            .filter { $0.sampleType == .quantityType(forIdentifier: type) }
            .compactMap { $0 as? HKCumulativeQuantitySample }
            .reduce(0) { $0 + $1.sumQuantity.doubleValue(for: unit) }
    }
}
