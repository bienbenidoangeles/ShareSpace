//
//  MainView.swift
//  ShareSpace
//
//  Created by Bienbenido Angeles on 5/24/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    public lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    public lazy var handleBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    public lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
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
            topView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.05),
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
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
