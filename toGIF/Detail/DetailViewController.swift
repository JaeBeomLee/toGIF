//
//  DetailViewController.swift
//  toGIF
//
//  Created by 이재범 on 08/11/2018.
//  Copyright © 2018 Jay_Lee. All rights reserved.
//

import UIKit
import Photos
import AVKit

class DetailViewController: UIViewController {

    var liveAsset: PHAsset?
    var moviePlayer: AVPlayerLayer!
    var videoURL: URL!
    @IBOutlet weak var containerView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let resources = PHAssetResource.assetResources(for: liveAsset!)
        resources.forEach{ resource in
            if resource.type == .pairedVideo {
                self.getMovieData(resource, asset: liveAsset!)
            }
        }
    }
    
    func getMovieData(_ resource: PHAssetResource, asset: PHAsset){
        
        let movieURL = URL(fileURLWithPath: (NSTemporaryDirectory()).appending(resource.originalFilename))
        removeFileIfExists(fileURL: movieURL)
        

        PHAssetResourceManager.default().writeData(for: resource, toFile: movieURL as URL, options: nil) { (error) in
            if error != nil{
                print("Could not write video file")
            } else {
                self.videoURL = movieURL
                let player = AVPlayer(url: movieURL)
                self.moviePlayer = AVPlayerLayer(player: player)
                self.moviePlayer.videoGravity = .resizeAspect
                self.moviePlayer.frame = self.containerView.bounds
                self.containerView.layer.addSublayer(self.moviePlayer)
                player.play()
                NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
                    player.seek(to: .zero)
                    player.play()
                }
//                self.convertToGIF(movieURL)
            }
        }
    }
    
    func removeFileIfExists(fileURL : URL) {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: fileURL.path) {
            do {
                try fileManager.removeItem(at: fileURL)
            }
            catch {
                print("Could not delete exist file so cannot write to it")
            }
        }
    }
    
}
