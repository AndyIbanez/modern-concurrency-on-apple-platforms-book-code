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
        if viewModel.loadingState == .idle && viewModel.images.isEmpty {
            VStack {
                Text("Nothing to show")
                Button("Load Images") {
                    viewModel.downloadImages()
                }
                .buttonStyle(.borderedProminent)
            }
            .onAppear {
                if viewModel.imageManager == nil {
                    viewModel.imageManager = imageManager
                }
            }
        } else if viewModel.loadingState == .downloading {
            ProgressView()
        } else {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.images, id: \.url) { serverImage in
                        ServerImageView(
                            serverImage: serverImage,
                            imageManager: imageManager
                        )
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
