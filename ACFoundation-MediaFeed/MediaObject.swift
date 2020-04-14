//
//  MediaObject.swift
//  ACFoundation-MediaFeed
//
//  Created by Liubov Kaper  on 4/13/20.
//  Copyright © 2020 Luba Kaper. All rights reserved.
//

import Foundation

// can be video or image
struct MediaObkject {
    let imageData: Data?
    let videoURL: URL?
    let caption: String? // UI so user can enter text
    let id = UUID().uuidString
    let createDate = Date()
}
