//
//  PostReservationCell.swift
//  ShareSpace
//
//  Created by Liubov Kaper  on 6/15/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit

class PostReservationCell: UICollectionViewCell {
    
    
    @IBOutlet weak var locationLabel: UILabel!
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var priceLabel: UILabel!
    
    
    @IBOutlet weak var spacePhoto: UIImageView!
    
    public func configureCell(for myPost: Post) {
        updateUI(imageURL: myPost.mainImage, title: myPost.postTitle, price: myPost.price.total.description, location: myPost.location?.fullAddress ?? "no address")
    }
    
    public func configureCell(for reservation: Reservation) {
        updateUI( title: reservation.checkIn.description, price: reservation.checkOut.description, location: reservation.postId)
    }
    
    
    private func updateUI(imageURL: String? = nil, title: String, price: String, location: String) {
        spacePhoto.kf.setImage(with: URL(string: imageURL ?? ""))
        locationLabel.text = location
        titleLabel.text = title
        priceLabel.text = price
    }
    
}
