//
//  ContentView.swift
//  CoreLocationAsyncStream
//
//  Created by Andy Ibanez on 7/5/22.
//

import SwiftUI
import CoreLocation

@MainActor
class ContentViewViewModel: ObservableObject {
    @Published private(set) var locations: [CLLocation] = []
    
    let locationUpdater = LocationUpdater()
    
    func startUpdating() async {
        let authorized = await locationUpdater.requestPermission()
        if [CLAuthorizationStatus.authorizedAlways, .authorizedWhenInUse].contains(authorized) {
            for await newCoordinate in locationUpdater.locations {
                locations += [newCoordinate]
            }
        }
    }
    
    func stopUpdating() {
        locationUpdater.stop()
    }
}

@MainActor
struct ContentView: View {
    @StateObject var viewModel = ContentViewViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.locations, id: \.hash) { location in
                Text("\(location.coordinate.longitude), \(location.coordinate.latitude)")
            }
            .navigationTitle("Locations")
            .task {
                await viewModel.startUpdating()
            }
            .navigationBarItems(
                leading: EmptyView(),
                trailing: Button("Stop Updating") {
                    viewModel.stopUpdating()
                }
            )
            .navigationViewStyle(.stack)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
