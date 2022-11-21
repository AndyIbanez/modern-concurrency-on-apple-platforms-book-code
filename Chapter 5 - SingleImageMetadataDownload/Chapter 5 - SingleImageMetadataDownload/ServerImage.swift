//
//  ServerImage.swift
//  Chapter 5 - SingleImageMetadataDownload
//
//  Created by Andy Ibanez on 6/16/22.
//

import Foundation

struct ServerImage: Codable {
    let imageName: String
    let url: URL
}
