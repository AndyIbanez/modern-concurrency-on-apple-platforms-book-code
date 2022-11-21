//
//  API.swift
//  Chapter 5 - SingleImageMetadataDownload
//
//  Created by Andy Ibanez on 6/16/22.
//

import Foundation

class API: ObservableObject {
    private let imageListURL = URL(string: "https://www.andyibanez.com/fairesepages.github.io/books/async-await/taskgroups/imagelist_tif.json")!
    private let metadataBaseURL = URL(string: "https://www.andyibanez.com/fairesepages.github.io/books/async-await/taskgroups/metadata")!
    private let deviceInfoURL = URL(string: "https://www.andyibanez.com/fairesepages.github.io/books/async-await/taskgroups/device")!
    
    init() {}
    
    func fetchImageList() async throws -> [ServerImage] {
        let (data, _) = try await URLSession.shared.data(from: imageListURL)
        let images = try JSONDecoder().decode([ServerImage].self, from: data)
        return images
    }
    
    func fetchImageMetadata(for imageName: String) async throws -> ImageMetadata {
        let builtURL = metadataBaseURL.appendingPathComponent("\(imageName).json")
        let (data, _) = try await URLSession.shared.data(from: builtURL)
        let metadata = try JSONDecoder().decode(ImageMetadata.self, from: data)
        return metadata
    }
    
    func fetchDeviceInfo(for deviceName: String) async throws -> DeviceInfo {
        let builtURL = deviceInfoURL.appendingPathComponent("\(deviceName).json")
        let (data, _) = try await URLSession.shared.data(from: builtURL)
        let metadata = try JSONDecoder().decode(DeviceInfo.self, from: data)
        return metadata
    }
    
    func fetchAllMetadata(for imageName: String) async throws -> (metadata: ImageMetadata, deviceInfo: DeviceInfo) {
        let metadata = try await fetchImageMetadata(for: imageName)
        let deviceInfo = try await fetchDeviceInfo(for: metadata.device)
        return (metadata, deviceInfo)
    }
    
    func downloadImageData(_ url: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}
