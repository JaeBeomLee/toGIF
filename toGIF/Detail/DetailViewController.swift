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
import SwiftyGif

class DetailViewController: UIViewController {
    var mode = 1
    var liveAsset: PHAsset?
    var moviePlayer: AVPlayerLayer!
    var videoURL: URL!
    var gifURL: URL!
    var player: AVPlayer?
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var gifView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let resources = ContentsManager.shared.assetResources(to: liveAsset!)
        resources.forEach{ resource in
            if resource.type == .pairedVideo {
                initURL(resource)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureVideoView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.player?.pause()
    }
    func initURL(_ resource: PHAssetResource){
        self.videoURL = ContentsManager.shared.videoURL(from: resource)
    }
    
    func configureVideoView() {
        self.player = AVPlayer(url: self.videoURL)
        self.moviePlayer = AVPlayerLayer(player: player)
        self.moviePlayer.videoGravity = .resizeAspect
        self.moviePlayer.frame = self.containerView.bounds
        self.containerView.layer.addSublayer(self.moviePlayer)
        self.player?.play()
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem, queue: .main) { _ in
            self.player?.seek(to: .zero)
            self.player?.play()
        }
    }
    
    func configureGifView(){
        let videoAsset = AVURLAsset(url: self.videoURL)
        
        let duration = CMTimeGetSeconds(videoAsset.duration)
        let track = videoAsset.tracks(withMediaType: .video).first!
        let frameRate = track.nominalFrameRate
        
        self.gifURL = ContentsManager.shared.convertGIF(from: self.videoURL, duration: Float(duration), frameRate: Int(frameRate))
        self.gifView.setGifFromURL(gifURL)
    }
    
}
