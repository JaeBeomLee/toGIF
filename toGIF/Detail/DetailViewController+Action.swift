//
//  DetailViewController+Action.swift
//  toGIF
//
//  Created by 이재범 on 2018. 11. 10..
//  Copyright © 2018년 Jay_Lee. All rights reserved.
//

import Foundation
import Photos
extension DetailViewController {
    @IBAction func convertButtonClicked(_ sender: Any) {
        PHPhotoLibrary.shared().performChanges({
            if self.mode == 0 {
                PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: self.gifURL)
            }else{
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self.videoURL)
            }
            
        }){ (isSaved, error) in
            if isSaved {
                let alert = UIAlertController(title: "Save Complete", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            
        }
    }
    
    @IBAction func clickedSegment(_ sender: UISegmentedControl) {
        mode = sender.selectedSegmentIndex
        switch sender.selectedSegmentIndex {
        case 0:
            self.containerView.isHidden = true
            self.player?.pause()
            self.gifView.isHidden = false
            configureGifView()
        case 1:
            self.gifView.isHidden = true
//            self.gifView.image = nil
            self.containerView.isHidden = true
            configureVideoView()
        default:
            break
        }
    }
}
