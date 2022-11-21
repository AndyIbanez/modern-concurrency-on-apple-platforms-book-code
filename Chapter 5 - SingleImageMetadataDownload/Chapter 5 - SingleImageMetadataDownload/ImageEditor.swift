//
//  ImageEditor.swift
//  Chapter 5 - SingleImageMetadataDownload
//
//  Created by Andy Ibanez on 6/19/22.
//

import Foundation
import UIKit

class ImageEditor: ObservableObject {
    func applyWhiteAndBlackFilter(to image: UIImage) -> UIImage {
        let imageRect = CGRect(x: 0, y: 0,width: image.size.width, height : image.size.height)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let context = CGContext(data: nil, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.none.rawValue)
        context?.draw(image.cgImage!, in: imageRect)

        let imageRef = context!.makeImage()
        let newImage = UIImage(cgImage: imageRef!)

        return newImage
    }
}
