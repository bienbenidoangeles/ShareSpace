//
//  MainView.swift
//  ShareSpace
//
//  Created by Bienbenido Angeles on 5/24/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit

class MainView: UIView {
    
    public lazy var searchBar : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Filter by results"
        return searchBar
    }()
    
    public lazy var mapButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "map"), for: .normal)
        return button
    }()
    
    public lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
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
        setupSearchBarConstrainsts()
        setupMapConstrainsts()
        setUpCollectionViewConstrainsts()
    }
    
    private func setupSearchBarConstrainsts(){
        addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
        ])
    }
    
    private func setupMapConstrainsts(){
        addSubview(mapButton)
        mapButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapButton.leadingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: 8),
            mapButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            mapButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8)
        ])
    }
    
    private func setUpCollectionViewConstrainsts(){
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            collectionView.topAnchor.constraint(equalTo: mapButton.bottomAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }
    
}
