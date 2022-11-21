//
//  ContentView.swift
//  TaskGroups
//
//  Created by Andy Ibanez on 5/30/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewViewModel()
    @EnvironmentObject private var imageManager: ImageManager
    
    var body: some View {
        ScrollView {
            LazyVStack {
                if let manager = viewModel.imageManager {
                    ForEach(manager.images) { imageDownload in
                        switch imageDownload.status {
                        case .error(_): imageErrorView()
                        case .downloading(_): imageDownloadView()
                        case .downloaded(let url): imageView(for: url)
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.imageManager = imageManager
            viewModel.downloadImages()
        }
    }
    
    @ViewBuilder
    func imageDownloadView() -> some View {
        VStack {
            Image(systemName: "photo")
                .resizable()
                .frame(width: 300, height: 300)
                .foregroundColor(.gray)
        }
    }
    
    @ViewBuilder
    func imageErrorView() -> some View {
        VStack {
            Image(systemName: "xmark")
                .resizable()
                .frame(width: 300, height: 300)
        }
    }
    
    @ViewBuilder
    func imageView(for url: URL) -> some View {
        Image(uiImage: UIImage(data: viewModel.data(for: url))!)
            .resizable()
            .frame(width: 300, height: 300)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
