//
//  ViewController.swift
//  toGIF
//
//  Created by 이재범 on 07/11/2018.
//  Copyright © 2018 Jay_Lee. All rights reserved.
//

import UIKit
import Photos

class MainViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var dataProvider = MainCollectionDataProvider()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = dataProvider
        
//        collectionView.delegate = self
        PHPhotoLibrary.requestAuthorization{ response in
            if response == PHAuthorizationStatus.authorized {
                self.configureData()
                DispatchQueue.main.async {
                    self.configureCollectionView()
                    self.collectionView.reloadData()
                }
                
            }else {
                let alert = UIAlertController(title: "We need Permission", message: "if you don't open library, you can't use toGIF ", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    
    func configureCollectionView(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 4, bottom: 10, right: 4)
        layout.itemSize = CGSize(width: (view.frame.width - 16) / 3, height: (view.frame.width - 16) / 3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 4
        collectionView!.collectionViewLayout = layout
    }
    
    func configureData(){
        let imgManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .fastFormat
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaSubtype == %ld", PHAssetMediaSubtype.photoLive.rawValue)
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
//        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        if fetchResult.count > 0 {
            for i in 0 ..< fetchResult.count {
                imgManager.requestImage(for: fetchResult.object(at: i),
                                        targetSize: CGSize(width: 200, height: 200),
                                        contentMode: .default,
                                        options: requestOptions){ (image, error) in
                                            self.dataProvider.images.append(image!)
                }
            }
        }else {
            print("You got no Photos!")
        }
    }

}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = view.frame.width / 3 - 20
        return CGSize(width: size, height: size)
    }
}


