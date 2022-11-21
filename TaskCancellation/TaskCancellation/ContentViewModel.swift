//
//  ContentViewModel.swift
//  TaskCancellation
//
//  Created by Andy Ibanez on 5/24/22.
//

import Foundation

@MainActor
class ContentViewViewModel: ObservableObject {
    @Published private(set) var firstTaskValues: [String] = []
    @Published private(set) var secondTaskValues: [String] = []
    
    @Published private(set) var mainTask: Task<Void, Never>?
    @Published private(set) var firstTask: Task<Void, Never>?
    @Published private(set) var secondTask: Task<Void, Never>?
    
    func startCounting() {
        resetValues()
        mainTask = Task {
            firstTask = Task {
                for i in (1...10) {
                    firstTaskValues += ["\(i)"]
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                }
            }
            secondTask = Task {
                for i in (11...20) {
                    secondTaskValues += ["\(i)"]
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                }
            }
        }
    }
    
    private func count(from: Int, to: Int, assigningTo: WritableKeyPath<ContentViewViewModel, [String]>) async {
        for i in (from...to) {
            firstTaskValues += ["\(i)"]
            try? await Task.sleep(nanoseconds: 1_000_000_000)
        }
    }
    
    private func resetValues() {
        firstTaskValues = []
        secondTaskValues = []
    }
    
    func reset() {
        firstTaskValues = []
        secondTaskValues = []
        mainTask = nil
        firstTask = nil
        secondTask = nil
    }
}
