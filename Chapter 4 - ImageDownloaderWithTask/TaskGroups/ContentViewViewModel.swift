//
//  ContentViewViewModel.swift
//  TaskGroups
//
//  Created by Andy Ibanez on 5/30/22.
//

import Foundation

enum LoadingState {
    case downloading
    case idle
}

@MainActor
class ContentViewViewModel: ObservableObject {
    var imageManager: ImageManager?
    @Published private(set) var images: [ServerImage] = []
    @Published private(set) var loadingState: LoadingState = .idle
    
    func downloadImages() {
        Task {
            loadingState = .downloading
            guard let manager = imageManager else { return }
            do {
                let imageList = try await manager.fetchImageList()
                self.images = imageList
            } catch {
                print(error)
            }
            loadingState = .idle
        }
    }
}
