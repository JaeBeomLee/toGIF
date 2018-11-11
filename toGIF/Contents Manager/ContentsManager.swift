//
//  ContentsManager.swift
//  toGIF
//
//  Created by 이재범 on 2018. 11. 11..
//  Copyright © 2018년 Jay_Lee. All rights reserved.
//

import Foundation
import Photos
class ContentsManager {
    static let shared: ContentsManager = {
        return ContentsManager()
    }()
    
    let imageManager = PHImageManager.default()
    func assets(to type: PHAssetMediaSubtype) -> PHFetchResult<PHAsset> {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaSubtype == %ld", type.rawValue)
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        return fetchResult
    }
    func images(to assets: PHFetchResult<PHAsset>, size: CGSize) -> [UIImage]{
        var images = [UIImage]()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .fastFormat
        
        for i in 0 ..< assets.count {
            imageManager.requestImage(for: assets.object(at: i), targetSize: size, contentMode: .default, options: requestOptions){ (image, error) in
                images.append(image!)
            }
        }
        
        return images
    }
}
