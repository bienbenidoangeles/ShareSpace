//
//  FeedExpandedCell.swift
//  ShareSpace
//
//  Created by Bienbenido Angeles on 6/4/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit
import Kingfisher

class FeedExpandedCell: UICollectionViewCell {
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var cellInfoBackgroundView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var accessoryButton: UIButton!
    @IBOutlet weak var detailInfoBackgroundView: UIView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    public func configureCell(for post: Post){
<<<<<<< Updated upstream
        if let imgURLs = post.images?.compactMap({URL(string: $0)}), let cityState = post.cityState {
=======
        if let imgURLs = post.images?.compactMap({URL(string: $0)}), let cityState = post.location?.cityState {
>>>>>>> Stashed changes
             let imgprocessor = DownsamplingImageProcessor(size: cellImageView.bounds.size)
                |> RoundCornerImageProcessor(cornerRadius: 8)
            let ratingImgprocessor = DownsamplingImageProcessor(size: ratingImageView.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 8)
            let profileImgProcessor = DownsamplingImageProcessor(size: profileImageView.bounds.size)
                |> RoundCornerImageProcessor(cornerRadius: profileImageView.bounds.width/2.0)
            topLabel.text = post.postTitle
            bottomLabel.text = cityState
            DispatchQueue.main.async {
                DatabaseService.shared.loadUser(userId: post.userId) { (result) in
                    switch result {
                    case .failure:
                        self.profileImageView.image = UIImage(systemName: "person.circle.fill")
                    case .success(let user):
                        if let userImg = user.profileImage {
                            self.profileImageView.kf.indicatorType = .activity
                            self.profileImageView.kf.setImage(with: URL(string: userImg), placeholder: nil, options: [.processor(profileImgProcessor)], progressBlock: nil)
                        }
                        
                    }
                }
            }
        }
    }
}

