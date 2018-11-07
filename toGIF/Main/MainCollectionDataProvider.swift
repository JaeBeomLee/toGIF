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
    var images = [UIImage]()
    override init() {
        
        
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
