//
//  MainCollectionDataProvider.swift
//  toGIF
//
//  Created by 이재범 on 07/11/2018.
//  Copyright © 2018 Jay_Lee. All rights reserved.
//

import UIKit
import Photos
class MainCollectionDataProvider: NSObject, UICollectionViewDataSource {
    var totalAssets = PHFetchResult<PHAsset>()
    var loadAssets = [PHAsset]()
    let loadCount = 30
    
    var totalPages = 1
    var currentPage = 1
    
    var images = [UIImage]()
    
    override init() {}
    
    func configureData(){
        self.images.append(contentsOf: ContentsManager.shared.images(to: totalAssets, size: CGSize(width: 200, height: 200)).compactMap{$0})
    }
    
    func initTotalAssets() {
        totalAssets = ContentsManager.shared.assets(to: .photoLive)
    }
    
    func initTotalPages(){
        totalPages = totalAssets.count / loadCount
        if totalAssets.count % loadCount != 0 {
            totalPages += 1
        }
    }
    
    func addCurrentPageAssets() {
        let startAssetCount = loadCount * (currentPage - 1)
        var endAssetCount = loadCount * currentPage
        if (totalAssets.count - loadCount * currentPage) < 0{
            endAssetCount += (totalAssets.count - loadCount * currentPage)
        }
        
        loadAssets = totalAssets.objects(at: IndexSet(integersIn: startAssetCount..<endAssetCount))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        cell.initView(to: images[indexPath.row])
        return cell
    }
}
