//
//  ProgrammaticPostReservationCell.swift
//  ShareSpace
//
//  Created by Liubov Kaper  on 6/16/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit
import Kingfisher

class ProgrammaticPostReservationCell: UICollectionViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
       // self.layer.borderWidth = 3
       // self.layer.borderColor = UIColor.sunnyYellow.cgColor
        self.layer.cornerRadius = 13
        postImage.clipsToBounds = true
        postImage.layer.cornerRadius = 13
    }
    
    public lazy var postImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "office")
        imageView.contentMode = .scaleAspectFill
       
        return imageView
        
        
    }()
    
    public lazy var postTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 21.0)
        label.textColor = .yummyOrange
        label.text = "Title"
        return label
    }()
    
    public lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.text = "Location"
        label.textColor = .yummyOrange
        return label
    }()
    
    public lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.text = "Price per day"
        label.textColor = .yummyOrange
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
       setupImageConstraints()
        setupPostTitleConstraints()
        locationLabelConstarints()
        setupPriceLabelConstraints()
        
    }
    
   private func setupImageConstraints() {
        addSubview(postImage)
        postImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postImage.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            postImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            postImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            postImage.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.70),
        ])
    }
    
    private func setupPostTitleConstraints() {
        addSubview(postTitle)
        postTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postTitle.topAnchor.constraint(equalTo: postImage.bottomAnchor, constant: 8),
            postTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            postTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    private func locationLabelConstarints() {
        addSubview(locationLabel)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
           locationLabel.topAnchor.constraint(equalTo: postTitle.bottomAnchor, constant: 8),
           locationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            locationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    private func setupPriceLabelConstraints() {
        addSubview(priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
    
    
    public func configureCell(for myPost: Post) {
        updateUI(imageURL: myPost.mainImage, title: myPost.postTitle, price: myPost.price.description, location: myPost.fullAddress ?? "no address")
    }
    
    public func configureCell(for reservation: Reservation) {
        postImage.image = UIImage(named: "office")
       
//        updateUI( title: reservation.checkIn.toString(givenFormat: "EEEE, MMM d, yyyy"), price: reservation.checkOut.toString(givenFormat: "EEEE, MMM d, yyyy"), location: reservation.reservationId)
    }
    
    
    private func updateUI(imageURL: String? = nil, title: String, price: String, location: String) {
           postImage.kf.setImage(with: URL(string: imageURL ?? ""))
           locationLabel.text = location
           postTitle.text = title
           priceLabel.text = price
       }
    
    private func updateUI2(iuiImage: UIImage, title: String, price: String, location: String) {
        postImage.image = UIImage(named: "office")
        locationLabel.text = location
        postTitle.text = title
        priceLabel.text = price
    }
}
