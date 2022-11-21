//
//  ContentView.swift
//  Chapter 2 Exercise
//
//  Created by Andy Ibanez on 5/26/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var healthManager: HealthManager
    @StateObject private var viewModel = ContentViewViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            Text("Total Steps: \(viewModel.totalSteps)")
            Text("Total Flights of Stairs: \(viewModel.totalFlightsClimbed)")
            Text("Total Calories Burned: \(viewModel.totalActiveCalsBurned)")
            Spacer()
        }
        .onAppear {
            if viewModel.healthManager == nil {
                viewModel.healthManager = healthManager
                viewModel.requestPermissionAndPopulate()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
