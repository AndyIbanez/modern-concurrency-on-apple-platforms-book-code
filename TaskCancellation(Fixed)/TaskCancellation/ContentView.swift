//
//  ContentView.swift
//  TaskCancellation
//
//  Created by Andy Ibanez on 5/24/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewViewModel()
    
    let columns = [GridItem(.fixed(30)), GridItem(.fixed(30)), GridItem(.fixed(30))]
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.firstTaskValues, id: \.self) {
                        Image(systemName: "\($0).circle")
                    }
                }
                if viewModel.firstTask?.isCancelled ?? false {
                    Text("firstTask Cancelled")
                        .foregroundColor(.red)
                }
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.secondTaskValues, id: \.self) {
                        Image(systemName: "\($0).circle")
                    }
                }
                if viewModel.secondTask?.isCancelled ?? false {
                    Text("secondTask Cancelled")
                        .foregroundColor(.red)
                }
            }
            if viewModel.mainTask?.isCancelled ?? false {
                Text("mainTask Cancelled")
                    .foregroundColor(.red)
            }
            if let _ = viewModel.mainTask {
                VStack(spacing: 10) {
                    Button("Cancel Main Task") {
                        viewModel.mainTask?.cancel()
                    }
                    Button("Cancel 1 to 10") {
                        viewModel.firstTask?.cancel()
                    }
                    Button("Cancel 11 to 20") {
                        viewModel.secondTask?.cancel()
                    }
                    Button("Reset") {
                        viewModel.reset()
                    }
                }
            } else {
                Button("Start Counters") {
                    viewModel.startCounting()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

