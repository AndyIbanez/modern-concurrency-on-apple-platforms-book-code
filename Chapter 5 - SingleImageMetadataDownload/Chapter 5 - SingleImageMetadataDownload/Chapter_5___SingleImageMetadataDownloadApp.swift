//___FILEHEADER___

import SwiftUI

fileprivate let api = API()
fileprivate let imageEditor = ImageEditor()

@main
struct SingleImageMetadataDownloadApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(api)
                .environmentObject(imageEditor)
        }
    }
}
