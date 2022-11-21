//
//  ContentViewViewModel.swift
//  TaskGroups
//
//  Created by Andy Ibanez on 5/30/22.
//

import Foundation

@MainActor
class ContentViewViewModel: ObservableObject {
    var imageManager: ImageManager?
    
    func downloadImages() {
        Task {
            guard let manager = imageManager else { return }
            do {
                let imageList = try await manager.fetchImageList()
                manager.download(serverImages: imageList)
            } catch {
                print(error)
            }
        }
    }
    
    func data(for url: URL) -> Data {
        return (try? Data(contentsOf: url)) ?? Data()
    }
}
