//
//  ImageManager.swift
//  TaskGroups
//
//  Created by Andy Ibanez on 5/30/22.
//

import Foundation

class ImageManager: ObservableObject {
    private let imageListURL = URL(string: "https://www.andyibanez.com/fairesepages.github.io/books/async-await/taskgroups/imagelist_tif.json")!
    private let urlSession = URLSession.shared
    private let jsonDecoder = JSONDecoder()
    
    func fetchImageList() async throws -> [ServerImage] {
        let (data, _) = try await urlSession.data(from: imageListURL)
        let urls = try jsonDecoder.decode([ServerImage].self, from: data)
        return urls
    }
    
    /// Returns the local image path.
    func download(_ serverImage: ServerImage) async throws -> URL {
        let fileManager = FileManager.default
        let tmpDir = fileManager.temporaryDirectory
        let (downloadedImageUrl, _) = try await urlSession.download(from: serverImage.url)
        let destinationUrl = tmpDir.appendingPathComponent(serverImage.imageName)
        // If the destination already exists, remove it.
        try? fileManager.removeItem(at: destinationUrl)
        try fileManager.moveItem(at: downloadedImageUrl, to: destinationUrl)
        return destinationUrl
    }
    
    /// Downloads all the images in te array and returns an array of URLs  to the local files
    func download(serverImages: [ServerImage]) async throws -> [URL] {
        var urls: [URL] = []
        try await withThrowingTaskGroup(of: URL.self) { group in
            for image in serverImages {
                group.addTask(priority: .userInitiated) {
                    let imageUrl = try await self.download(image)
                    return imageUrl
                }
            }
            
            for try await imageUrl in group {
                urls.append(imageUrl)
            }
        }
        return urls
    }
}
