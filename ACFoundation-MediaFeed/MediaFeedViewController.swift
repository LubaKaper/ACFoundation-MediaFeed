//
//  ViewController.swift
//  ACFoundation-MediaFeed
//
//  Created by Liubov Kaper  on 4/13/20.
//  Copyright © 2020 Luba Kaper. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class MediaFeedViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var videoButton: UIBarButtonItem!
    
    @IBOutlet weak var photoButton: UIBarButtonItem!
    
    private lazy var imagePickerController: UIImagePickerController = {
        // photo and video
        let mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)
        let pickerController = UIImagePickerController()
        
        pickerController.mediaTypes = mediaTypes ?? ["kUTTypeImage"]
        pickerController.delegate = self
        return pickerController
    }()
    
    private var mediaObjects = [MediaObkject]() {
        didSet {
            collectionView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            videoButton.isEnabled = false
        }
    }
    
    private func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    @IBAction func videoButtonPressed(_ sender: UIBarButtonItem) {
        
       imagePickerController.sourceType = .camera
       present(imagePickerController, animated: true)
    }
    
    @IBAction func photoButtonPressed(_ sender: UIBarButtonItem) {
        
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    // function to play random videos in headerview
    private func playRandomVideo(in view: UIView) {
        // we want all non-nil media objects from mediaObjects array
        // compactMap - it returns all non-nil values
        let videoURLs = mediaObjects.compactMap { $0.videoURL } // only returns videos, no photos
        // get random video
        if let videoURL = videoURLs.randomElement() {
            let player = AVPlayer(url: videoURL)
            
            // create a sublayer
            let playerLayer = AVPlayerLayer(player: player)
            // set its frame
            playerLayer.frame = view.bounds
            
            // set video aspect rastio
            playerLayer.videoGravity = .resizeAspect
            
            // remove all sublayers from the header view
            view.layer.sublayers?.removeAll()
            
            // add playerLayer to the headerView's layer
            view.layer.addSublayer(playerLayer)
            
            //play video
            player.play()
        }
    }
    
    
}

// MARK: UIcollection View Data Source methods

extension MediaFeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mediaCell", for: indexPath) as? MediaCell else {
            fatalError("could not dequeue to media cell")
        }
        let object = mediaObjects[indexPath.row]
        cell.configureCell(for: object)
        return cell
    }
    // header view function
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView", for: indexPath) as? HeaderView else {
            fatalError("could not dequeue a HeaderView")
        }
        playRandomVideo(in: headerView)
        return headerView
    }
}

// MARK: UIcollection View Delegate methods

extension MediaFeedViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mediaObject = mediaObjects[indexPath.row]
        guard let videoURL = mediaObject.videoURL else {
            return
        }
        let playerViewController = AVPlayerViewController()
        let player = AVPlayer(url: videoURL)
        playerViewController.player = player
        present(playerViewController, animated: true)
        // play video automatically
        player.play()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize: CGSize = UIScreen.main.bounds.size
        let itemWidth: CGFloat = maxSize.width
        let itemHeight: CGFloat = maxSize.height * 0.40
        return CGSize(width: itemWidth, height: itemHeight)
        
    }
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
       }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height * 0.40)
    }
}


extension MediaFeedViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // InfoKey.originalImage
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String else  {
            return
        }
        
        switch mediaType {
        case "public.image":
            if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let imageData = originalImage.jpegData(compressionQuality: 1.0) {
                let mediaObject = MediaObkject(imageData: imageData, videoURL: nil, caption: nil)
                mediaObjects.append(mediaObject)
            }
        case "public.movie":
            if let mediaURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                print("MEDIA url: \(mediaURL)")
                let mediaObject = MediaObkject(imageData: nil, videoURL: mediaURL, caption: nil)
                mediaObjects.append(mediaObject)
            }
        default:
            print("unsupported media type")
        }
        print("mediaType: \(mediaType)")// public.video, public.image
        
        picker.dismiss(animated: true)
    }
}
