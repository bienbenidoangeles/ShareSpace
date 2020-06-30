//
//  FeedCell.swift
//  ShareSpace
//
//  Created by Bienbenido Angeles on 5/27/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit

class FeedCell: UICollectionViewCell {
    
    private lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo.fill")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configureCell(for post: Post){
        locationLabel.text = post.streetAddress
        ratingLabel.text = "\(post.rating ?? 0.0) out of 5 stars"
        titleLabel.text = "\(post.postTitle)"
        priceLabel.text = "$\(post.price)"
    }
    
    private func commonInit(){
        setupImageViewConstrainsts()
        setupLocationLabelConstrainsts()
        setupRatingLabelConstrainsts()
        setupTitleLabelConstrainsts()
        setupPriceLabelConstrainsts()
    }
    
    private func setupImageViewConstrainsts(){
        addSubview(postImageView)
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postImageView.topAnchor.constraint(equalTo: topAnchor),
            postImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            postImageView.widthAnchor.constraint(equalTo: widthAnchor),
            postImageView.heightAnchor.constraint(equalTo: postImageView.widthAnchor, multiplier: 9.0/16.0)
        ])
    }
    
    private func setupLocationLabelConstrainsts(){
        addSubview(locationLabel)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 8),
            locationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
        ])
    }
    
    private func setupRatingLabelConstrainsts(){
        addSubview(ratingLabel)
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ratingLabel.leadingAnchor.constraint(equalTo: locationLabel.trailingAnchor, constant: 8),
            ratingLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 8),
            ratingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8),
            ratingLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3)
        ])
    }
    
    private func setupTitleLabelConstrainsts(){
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
    
    private func setupPriceLabelConstrainsts(){
        addSubview(priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8),
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
}
