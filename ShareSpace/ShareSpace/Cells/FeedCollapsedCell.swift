//
//  FeedCollapsedCell.swift
//  ShareSpace
//
//  Created by Bienbenido Angeles on 6/4/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit
import Kingfisher

class FeedCollapsedCell: UICollectionViewCell {
    
    @IBOutlet weak var feedMainImageView: UIImageView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var accessoryButton: UIButton!
    @IBOutlet weak var cellBackGroundView: UIView!
    
    public func configureCell(for post: Post){
        if let mainImgURL = URL(string: post.mainImage), let ratingImgURL = URL(string: post.rating?.ratingImage ?? "ax") {
             let mainImgprocessor = DownsamplingImageProcessor(size: feedMainImageView.bounds.size)
                |> RoundCornerImageProcessor(cornerRadius: 8)
            let ratingImgProcessor = DownsamplingImageProcessor(size: ratingImageView.bounds.size)
                |> RoundCornerImageProcessor(cornerRadius: 8)
            DispatchQueue.main.async {
                self.feedMainImageView.kf.indicatorType = .activity
                self.feedMainImageView.kf.setImage(with: mainImgURL, placeholder: UIImage(systemName: "photo.fill"), options: [.processor(mainImgprocessor)], progressBlock: nil)
                self.ratingImageView.kf.indicatorType = .activity
                self.ratingImageView.kf.setImage(with: ratingImgURL, placeholder: UIImage(systemName: "star.fill"), options: [.cacheOriginalImage, .processor(ratingImgProcessor)], progressBlock: nil)
            }
        }
        topLabel.text = post.postTitle
    }
}
