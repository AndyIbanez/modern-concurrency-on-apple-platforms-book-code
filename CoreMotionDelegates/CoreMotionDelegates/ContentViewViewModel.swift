//
//  ContentViewViewModel.swift
//  CoreMotionDelegates
//
//  Created by Andy Ibanez on 7/9/22.
//

import Foundation
import CoreMotion

@MainActor
class ContentViewViewModel: ObservableObject {
    let motionManager: CMMotionManager = CMMotionManager()
    let updateInterval = 0.5
    
    @Published private(set) var acceleration: CMAcceleration?
    
    func startMotionTracking() {
        let queue = OperationQueue()
        motionManager.accelerometerUpdateInterval = updateInterval
        motionManager.startAccelerometerUpdates(to: queue) { data, error in
            print(data?.acceleration)
        }
    }
}
