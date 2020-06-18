//
//  MyPostsReservationsView.swift
//  ShareSpace
//
//  Created by Liubov Kaper  on 6/16/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit

class MyPostsReservationsView: UIView {
    
    public lazy var segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl()
        sc.insertSegment(withTitle: "My Listings", at: 0, animated: true)
        sc.insertSegment(withTitle: "My reservations", at: 1, animated: true)
        sc.insertSegment(withTitle: "My Stays", at: 2, animated: true)
        sc.selectedSegmentTintColor = .yummyOrange
        sc.backgroundColor = .oceanBlue
        sc.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        sc.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        return sc
        
    }()
    
    
    
    public lazy var postsReservationsCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemBackground
        return cv
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
        setupSegmentedControlConstraints()
        setupCollectionViewConstraint()
    }
    
    private func setupSegmentedControlConstraints() {
        addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            segmentedControl.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8),
            segmentedControl.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8)
        ])
    }
    
    private func setupCollectionViewConstraint() {
        addSubview(postsReservationsCV)
        postsReservationsCV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postsReservationsCV.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8),
            postsReservationsCV.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 0),
            postsReservationsCV.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: 0),
            postsReservationsCV.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }

}
