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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let resources = ContentsManager.shared.resources(to: liveAsset!)
        resources.forEach{ resource in
            if resource.type == .pairedVideo {
                configureView(resource)
            }
        }
    }
    
    func configureView(_ resource: PHAssetResource) {
        self.videoURL = ContentsManager.shared.videoURL(from: resource)
        let player = AVPlayer(url: self.videoURL)
        self.moviePlayer = AVPlayerLayer(player: player)
        self.moviePlayer.videoGravity = .resizeAspect
        self.moviePlayer.frame = self.containerView.bounds
        self.containerView.layer.addSublayer(self.moviePlayer)
        player.play()
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
            player.seek(to: .zero)
            player.play()
        }
    }
    
}
