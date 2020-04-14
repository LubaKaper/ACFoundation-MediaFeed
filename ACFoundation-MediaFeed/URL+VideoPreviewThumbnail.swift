//
//  URL+VideoPreviewThumbnail.swift
//  ACFoundation-MediaFeed
//
//  Created by Liubov Kaper  on 4/13/20.
//  Copyright © 2020 Luba Kaper. All rights reserved.
//
import UIKit
import AVFoundation

extension URL {
    public func videoPreviewThumbnail() -> UIImage? {
        
        // create an AVAsset instance
        // e.g mediaObject.videoURL
        let asset = AVAsset(url: self)
        // The AVAssetImageGenerator in an AVFoundation class that converts a given media url to an image
        let assetGenerator = AVAssetImageGenerator(asset: asset)
        
        // we want to maintain the aspect ratio of the video
        assetGenerator.appliesPreferredTrackTransform = true
        
        // cresate a timestamp of needed location in the video
        // we will use a CMTime to generate the given timeStamp
        // CMTime is party of Core Media
        let timestamp = CMTime(seconds: 1, preferredTimescale: 60)
        // retrieving first second of the video
        
        var image: UIImage?
        do {
            let cgImage = try assetGenerator.copyCGImage(at: timestamp, actualTime: nil)
            image = UIImage(cgImage: cgImage)
            // lower level API dont know about UIKit, AVKit \
            // change the color of the UIView border
           // e.g someView.layer.borderColor = UIColor.green.cgColor
        } catch {
          print("failed to generate image \(error)")
        }
        return image
    }
}
