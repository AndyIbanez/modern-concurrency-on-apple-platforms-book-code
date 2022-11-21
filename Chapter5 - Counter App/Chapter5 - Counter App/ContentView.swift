//
//  ContentView.swift
//  Chapter5 - Counter App
//
//  Created by Andy Ibanez on 6/19/22.
//

import SwiftUI

@MainActor
class ContentViewViewModel: ObservableObject {
    @Published private(set) var values1To10: [Int] = []
    @Published private(set) var values11to20: [Int] = []
    @Published private(set) var error: Error?
    private(set) var counterTask: Task<Void, Never>?
    @Published private(set) var isCounting = false
    
    func countFrom1To10() async throws -> Bool {
        for i in (1...10) {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            if Task.isCancelled { return false }
            values1To10 += [i]
            if Task.isCancelled { return false }
        }
        return true
    }
    
    func countFrom11To20() async throws -> Bool {
        for i in (11...20) {
            if Task.isCancelled { return false }
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            values11to20 += [i]
            if Task.isCancelled { return false }
        }
        return true
    }
    
    func startCounting() {
        isCounting = true
        counterTask = Task {
            async let counter1To10DidFinish = countFrom1To10()
            async let counter11To20DidFinish = countFrom11To20()
            do {
                let _ = try await (counter1To10DidFinish, counter11To20DidFinish)
            } catch {
                self.error = error
            }
        }
    }
}

struct ContentView: View {
    @StateObject private var viewModel = ContentViewViewModel()
    
    let columns = [GridItem(.fixed(30)), GridItem(.fixed(30)), GridItem(.fixed(30))]
    
    var body: some View {
        if let _ = viewModel.error {
            Text("An Error has occured")
                .foregroundColor(.red)
        }
        if viewModel.isCounting {
            VStack {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.values1To10, id: \.self) {
                        Image(systemName: "\($0).circle")
                    }
                }
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.values11to20, id: \.self) {
                        Image(systemName: "\($0).circle")
                    }
                }
                Spacer()
                Button("Cancel") {
                    viewModel.counterTask?.cancel()
                }
            }
        } else {
            Button("Start Counting") {
                viewModel.startCounting()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

