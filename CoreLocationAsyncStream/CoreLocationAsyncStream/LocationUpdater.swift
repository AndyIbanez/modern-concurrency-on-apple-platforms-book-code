//
//  LocationUpdater.swift
//  CoreLocationAsyncStream
//
//  Created by Andy Ibanez on 7/5/22.
//

import Foundation
import CoreLocation

class LocationUpdater: NSObject, CLLocationManagerDelegate {
    private(set) var authorizationStatus: CLAuthorizationStatus
    
    private let locationManager: CLLocationManager
    
    // The continuation we will use to asynchronously ask the user permission to track their location.
    private var permissionContinuation: CheckedContinuation<CLAuthorizationStatus, Never>?
    private var streamContinuation: AsyncStream<CLLocation>.Continuation?
    
    override init() {
        locationManager = CLLocationManager()
        authorizationStatus = locationManager.authorizationStatus
        
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    var locations: AsyncStream<CLLocation> {
        let stream = AsyncStream(CLLocation.self) { continuation in
            continuation.onTermination = { @Sendable _ in
                self.stop()
                self.streamContinuation = nil
            }
            self.streamContinuation = continuation
            self.start()
        }
        return stream
    }
    
    func start() {
        locationManager.startUpdatingLocation()
    }
    
    func stop() {
        locationManager.stopUpdatingLocation()
        streamContinuation?.finish()
    }
    
    func requestPermission() async -> CLAuthorizationStatus {
        locationManager.requestWhenInUseAuthorization()
        
        if authorizationStatus != .notDetermined {
            return authorizationStatus
        }
        
        return await withCheckedContinuation { continuation in
            permissionContinuation = continuation
        }
    }
    
    // MARK: - Location Delegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.forEach { streamContinuation?.yield($0) }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        permissionContinuation?.resume(returning: authorizationStatus)
    }
}

