//
//  ImageCell.swift
//  toGIF
//
//  Created by 이재범 on 07/11/2018.
//  Copyright © 2018 Jay_Lee. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    
    func initView(to image: UIImage){
        self.image.image = image
    }
}
