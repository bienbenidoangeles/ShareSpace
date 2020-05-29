//
//  ListingDetailView.swift
//  ShareSpace
//
//  Created by Liubov Kaper  on 5/29/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit

class ListingDetailView: UIView {
    
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemBackground
        return cv
    }()
    
    
    public lazy var listingImageView: UIImageView = {
        let imageView = UIImageView()
    
    imageView.image = UIImage(systemName: "person.fill")
    imageView.contentMode = .scaleAspectFill
    imageView.layoutSubviews()
    imageView.backgroundColor = .systemOrange

       imageView.tintColor = .systemYellow
    
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame:UIScreen.main.bounds)
        commomInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        commomInit()
    }
    
    private func commomInit() {
        
    }

}
