//
//  ServerImageView.swift
//  TaskGroups
//
//  Created by Andy Ibanez on 6/21/22.
//

import Foundation
import SwiftUI

@MainActor
class ServerImageViewModel: ObservableObject {
    
    @Published private(set) var loadingState: LoadingState = .downloading
    
    private var downloadTask: Task<Data, Error>?
    
    var imageData: Data? {
        get async throws {
            self.downloadTask = Task {
                let url = try await imageManager.download(serverImage)
                let data = try Data(contentsOf: url)
                return data
            }
            return try await self.downloadTask?.value
        }
    }
    
    let serverImage: ServerImage
    let imageManager: ImageManager
    
    init(serverImage: ServerImage, imageManager: ImageManager) {
        self.serverImage = serverImage
        self.imageManager = imageManager
    }
    
    func cancelDownload() {
        downloadTask?.cancel()
    }
}

struct ServerImageView: View {
    @StateObject private var viewModel: ServerImageViewModel
    @State private var imageData: Data?
    @State private var error: Error?
    
    init(serverImage: ServerImage, imageManager: ImageManager) {
        self._viewModel = StateObject(wrappedValue: ServerImageViewModel(serverImage: serverImage, imageManager: imageManager))
    }
    
    var body: some View {
        Group {
        if let _ = error {
            VStack {
                Text("Error loading image")
                    .foregroundColor(.red)
                Button("Retry") {
                    self.error = nil
                    self.imageData = nil
                }
            }
        } else if let imageData = imageData, let image = UIImage(data: imageData) {
            Image(uiImage: image)
                .resizable()
                .frame(width: 300, height: 300)
        } else {
            VStack {
                ProgressView()
                    .task {
                        do {
                            self.imageData = try await viewModel.imageData
                        } catch {
                            self.error = error
                        }
                    }
                Button("Cancel") {
                    viewModel.cancelDownload()
                }
            }
        }
    }
        .frame(width: 300, height: 300)
        .overlay {
            if imageData == nil {
                RoundedRectangle(cornerRadius: 25).stroke(Color.gray)
            }
        }
    }
}
