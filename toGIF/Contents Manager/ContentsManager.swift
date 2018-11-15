//
//  ContentsManager.swift
//  toGIF
//
//  Created by 이재범 on 2018. 11. 11..
//  Copyright © 2018년 Jay_Lee. All rights reserved.
//

import Foundation
import Photos
import Regift

class ContentsManager {
    static let shared: ContentsManager = {
        return ContentsManager()
    }()
    
    let imageManager = PHImageManager.default()
    let fileManager = FileManager.default
    
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
        requestOptions.deliveryMode = .highQualityFormat
        
        for i in 0 ..< assets.count {
            imageManager.requestImage(for: assets.object(at: i), targetSize: size, contentMode: .default, options: requestOptions){ (image, error) in
                autoreleasepool{
                    images.append(image!)
                }
            }
        }
        
        return images
    }
    
    func assetResources(to asset: PHAsset) -> [PHAssetResource] {
        return PHAssetResource.assetResources(for: asset)
    }
    
    func videoURL(from resource: PHAssetResource) -> URL?{
        let url = URL(fileURLWithPath: (NSTemporaryDirectory()).appending("video.mov"))
        removeFileIfExists(fileURL: url)
        
        PHAssetResourceManager.default().writeData(for: resource, toFile: url, options: nil){ error in }
        
        if isFileExist(this: url) {
            return url
        }else {
            return nil
        }
        
    }
    
    func convertGIF(from video: URL, duration: Float, frameRate: Int) -> URL? {
        var result: URL?
        
        Regift.createGIFFromSource(video, startTime: 0.0, duration: duration, frameRate: frameRate){ url in
            result = url
        }
        
        return result
    }
    
    private func isFileExist(this url: URL)-> Bool{
        return fileManager.fileExists(atPath: url.path)
    }
    
    private func removeFileIfExists(fileURL : URL) {
        if isFileExist(this: fileURL) {
            do {
                try fileManager.removeItem(at: fileURL)
            }
            catch {
                print("Could not delete exist file so cannot write to it")
            }
        }
    }
}
