//
//  VideoCell.swift
//  ACFoundation-MediaFeed
//
//  Created by Liubov Kaper  on 4/13/20.
//  Copyright © 2020 Luba Kaper. All rights reserved.
//

import UIKit

class MediaCell: UICollectionViewCell {
    
    
    @IBOutlet weak var mediaImageView: UIImageView!
    
    public func configureCell(for mediaObject: MediaObkject) {
        
        
       if let imageData = mediaObject.imageData {
        
        // converts data object to UIImage
        mediaImageView.image = UIImage(data: imageData)
        }
        
        if let videoURL = mediaObject.videoURL {
            let image = videoURL.videoPreviewThumbnail() ?? UIImage(systemName: "heart")
            mediaImageView.image = image
        }
    }
    
}
