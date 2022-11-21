//
//  ImageMetadata.swift
//  Chapter 5 - SingleImageMetadataDownload
//
//  Created by Andy Ibanez on 6/16/22.
//

import Foundation

struct ImageMetadata: Codable {
    let device: String
    let lens: String
    let dimensions: String
}

struct DeviceInfo: Codable {
    let brand: String
    let model: String
    let year: Int
}
