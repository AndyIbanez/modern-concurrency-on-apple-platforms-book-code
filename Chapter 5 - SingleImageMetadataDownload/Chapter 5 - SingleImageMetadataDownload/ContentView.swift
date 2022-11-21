//
//  ContentView.swift
//  Chapter 5 - SingleImageMetadataDownload
//
//  Created by Andy Ibanez on 6/16/22.
//

import SwiftUI

enum DownloadStatus {
    case idle
    case downloading
}

typealias FullMetadata = (metadata: ImageMetadata, deviceInfo: DeviceInfo)

@MainActor
class ContentViewViewModel: ObservableObject {
    var api: API!
    var imageEditor: ImageEditor!
    @Published private(set) var imageData: Data?
    @Published private(set) var metadata: ImageMetadata?
    @Published private(set) var deviceInfo: DeviceInfo?
    @Published private(set) var error: Error?
    @Published private(set) var status = DownloadStatus.idle
    private(set) var downloadTask: Task<Void, Error>?
    
    private func downloadImage() async throws -> (fullMetadata: FullMetadata, imageData: Data) {
        let images = try await api.fetchImageList()
        let robertitoImage = images.first { $0.imageName.caseInsensitiveCompare("Robertito") == .orderedSame }
        guard let robertitoImage = robertitoImage else { fatalError("Expected image does not exist") }
        
        async let imageData = downloadAndApplyFilterToImage(imageURL: robertitoImage.url)
        async let metadata = api.fetchAllMetadata(for: robertitoImage.imageName)
        return try await (metadata, imageData)
    }
    
    func downloadAndApplyFilterToImage(imageURL: URL) async throws -> Data {
        let imageData = try await api.downloadImageData(imageURL)
        let newImage = convertImageDataToBlackAndWhite(imageData: imageData)
        return newImage
    }
    
    func convertImageDataToBlackAndWhite(imageData: Data) -> Data {
        let image = UIImage(data: imageData)!
        let newImage = imageEditor.applyWhiteAndBlackFilter(to: image)
        return newImage.jpegData(compressionQuality: 10)!
    }
    
    public func populateViewData() {
        downloadTask = Task {
            self.status = .downloading
            do {
                let (metadata, imageData) = try await downloadImage()
                self.metadata = metadata.metadata
                self.deviceInfo = metadata.deviceInfo
                self.imageData = imageData
            } catch {
                print("Error: \(error)")
                self.error = error
            }
            self.status = .idle
        }
    }
}

struct ContentView: View {
    @StateObject private var viewModel = ContentViewViewModel()
    @EnvironmentObject private var api: API
    @EnvironmentObject private var imageEditor: ImageEditor
    
    var body: some View {
        if viewModel.status == .downloading {
            VStack {
                ProgressView()
                Spacer()
                Button("Cancel") {
                    viewModel.downloadTask?.cancel()
                }
            }
        } else {
            VStack {
                if let _ = viewModel.error {
                    Text("Error downloading image")
                        .foregroundColor(.red)
                } else if let imageData = viewModel.imageData, let metadata = viewModel.metadata, let deviceInfo = viewModel.deviceInfo, let image = UIImage(data: imageData) {
                    HStack {
                        Spacer()
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 500, height: 500)
                        Spacer()
                    }
                    GroupBox {
                        VStack(alignment: .leading) {
                            Text("Device: \(metadata.device) (\(deviceInfo.year))")
                            Text("Brand: \(deviceInfo.brand)")
                            Text("Lens: \(metadata.lens)")
                            Text("Size: \(metadata.dimensions)")
                        }
                    }
                } else {
                    Text("Press the button to download the image")
                }
                Spacer()
                Button("Download Image") {
                    viewModel.populateViewData()
                }
            }
            .onAppear {
                viewModel.api = api
                viewModel.imageEditor = imageEditor
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
