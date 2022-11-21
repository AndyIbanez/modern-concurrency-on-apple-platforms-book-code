//
//  ImageManager.swift
//  TaskGroups
//
//  Created by Andy Ibanez on 5/30/22.
//

import Foundation
import UIKit

enum ImageDownloadStatus {
    case downloading(_ task: Task<Void, Never>)
    case error(_ error: Error)
    case downloaded(_ localImageURL: URL)
}

struct ImageDownload: Identifiable {
    let id: UUID = UUID()
    let status: ImageDownloadStatus
}

@MainActor
class ImageManager: ObservableObject {
    private let imageListURL = URL(string: "https://www.andyibanez.com/fairesepages.github.io/books/async-await/taskgroups/imagelist_tif.json")!
    private let urlSession = URLSession.shared
    private let jsonDecoder = JSONDecoder()
    
    @Published private(set) var images: [ImageDownload] = []
    
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
    
    func download(serverImages: [ServerImage]) {
        for imageIndex in (0..<serverImages.count) {
            let downloadTask = Task<Void, Never> {
                do {
                    let imageUrl = try await download(serverImages[imageIndex])
                    self.images[imageIndex] = ImageDownload(status: .downloaded(imageUrl))
                } catch {
                    self.images[imageIndex] = ImageDownload(status: .error(error))
                }
            }
            images.append(ImageDownload(status: .downloading(downloadTask)))
        }
    }
}
