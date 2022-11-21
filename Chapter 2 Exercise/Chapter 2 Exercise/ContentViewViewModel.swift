//
//  ContentViewViewModel.swift
//  Chapter 2 Exercise
//
//  Created by Andy Ibanez on 5/26/22.
//

import Foundation
import HealthKit

class ContentViewViewModel: ObservableObject {
    @Published private(set) var totalSteps: Double = 0
    @Published private(set) var totalFlightsClimbed: Double = 0
    @Published private(set) var totalActiveCalsBurned: Double = 0
    @Published private(set) var error: Error?
    
    var healthManager: HealthManager?
    
    private func requestHealthPermission(completionHandler: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        healthManager?.requestPermissions(completionHandler: completionHandler)
    }
    
    private func requestData(
        completionHandler: @escaping (_ sampleQuery: HKSampleQuery, _ samples: [HKSample]?, _ error: Error?) -> Void
    ) {
        healthManager?.requestData(completionHandler: completionHandler)
    }
    
    func requestPermissionAndPopulate() {
        requestHealthPermission { success, error in
            if success {
                self.requestData { sampleQuery, samples, error in
                    DispatchQueue.main.async {
                        if let error = error {
                            self.error = error
                        } else if let samples = samples {
                            self.totalSteps = self.getData(from: samples, for: .stepCount, unit: .count())
                            self.totalFlightsClimbed = self.getData(from: samples, for: .flightsClimbed, unit: .count())
                            self.totalActiveCalsBurned = self.getData(from: samples, for: .activeEnergyBurned, unit: .kilocalorie())
                        }
                    }
                }
            }
        }
    }
    
    private func getData(from samples: [HKSample], for type: HKQuantityTypeIdentifier, unit: HKUnit) -> Double {
        samples
            .filter { $0.sampleType == .quantityType(forIdentifier: type) }
            .compactMap { $0 as? HKCumulativeQuantitySample }
            .reduce(0) { $0 + $1.sumQuantity.doubleValue(for: unit) }
    }
}
