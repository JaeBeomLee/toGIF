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
        
        PHPhotoLibrary.requestAuthorization{ response in
            if response == PHAuthorizationStatus.authorized {
                self.dataProvider.initTotalAssets()
                self.dataProvider.initTotalPages()
                self.dataProvider.addCurrentPageAssets()
                self.dataProvider.configureData()
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
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = collectionView.indexPathsForSelectedItems?.first {
            let detailController = segue.destination as! DetailViewController
            detailController.liveAsset = ContentsManager.shared.assets(to: .photoLive)[indexPath.item]
            
        }
    }

}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = view.frame.width / 3 - 20
        return CGSize(width: size, height: size)
    }
}


