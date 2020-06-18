//
//  ListingPhotosCell.swift
//  ShareSpace
//
//  Created by Liubov Kaper  on 5/29/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit

class ListingPhotosCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 13
        imageView.clipsToBounds = true 
        imageView.layer.cornerRadius = 13
    }
    
    public func updateCell() {
        
    }
}
