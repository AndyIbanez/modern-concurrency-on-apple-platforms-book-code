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
    @Published private(set) var imageUrls: [URL] = []
    @Published private(set) var loadingState: LoadingState = .idle
    
    func downloadImages() {
        Task {
            loadingState = .downloading
            guard let manager = imageManager else { return }
            do {
            let imageList = try await manager.fetchImageList()
            let imageUrls = try await manager.download(serverImages: imageList)
                self.imageUrls = imageUrls
            } catch {
                print(error)
            }
            loadingState = .idle
        }
    }
    
    func data(for url: URL) -> Data {
        return (try? Data(contentsOf: url)) ?? Data()
    }
}
