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
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self.videoURL)
        }){ (isSaved, error) in
            if isSaved {
                let alert = UIAlertController(title: "Save Complete", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            
        }
    }
}
