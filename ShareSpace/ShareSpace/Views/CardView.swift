//
//  MainView.swift
//  ShareSpace
//
//  Created by Bienbenido Angeles on 5/24/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    override func layoutSubviews() {
        handleBarView.clipsToBounds = true
        handleBarView.layer.cornerRadius = 4
    }
    
    public lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.5)
        return view
    }()
    
    public lazy var handleBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    public lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        return cv
    }()
            
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit(){
        setUpTopView()
        setUpHandleBarView()
        setUpCollectionViewConstrainsts()
    }
    
    private func setUpTopView(){
        addSubview(topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topView.topAnchor.constraint(equalTo: topAnchor),
            topView.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    private func setUpHandleBarView(){
        topView.addSubview(handleBarView)
        handleBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            handleBarView.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            handleBarView.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            handleBarView.widthAnchor.constraint(equalTo: topView.widthAnchor, multiplier: 0.16),
            handleBarView.heightAnchor.constraint(equalTo: topView.heightAnchor, multiplier: 0.2),
        ])
    }
    
    private func setUpCollectionViewConstrainsts(){
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            collectionView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
