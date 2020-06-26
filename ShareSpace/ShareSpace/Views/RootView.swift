//
//  RootView.swift
//  ShareSpace
//
//  Created by Bienbenido Angeles on 6/3/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit
import MapKit

class RootView: UIView {
    
    public lazy var mapView:MKMapView = {
        let map = MKMapView()
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        return map
    }()
    
    public lazy var searchBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        //view.layoutSubviews()
        return view
    }()
    
    public lazy var searchLabel : UITextField = {
        let tf = UITextField()
        //tf.placeholder = "I want to go to..."
        tf.attributedPlaceholder = NSAttributedString(string: "I want to go to...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemTeal])
        tf.textColor = .systemTeal
        tf.isUserInteractionEnabled = true
        return tf
    }()
    
    public lazy var dateTimeButton: UIButton = {
        let button = UIButton()
        button.setTitle(" Now?", for: .normal)
        button.setImage(UIImage(systemName: "clock.fill"), for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .callout)
        button.setTitleColor(.systemBackground, for: .normal)
        button.tintColor = .systemBackground
        button.backgroundColor = .systemOrange
        button.layer.cornerRadius = 12
        return button
    }()
    
    public lazy var searchByMapViewButton: UIButton = {
        let button = UIButton()
        button.setTitle("Search this area", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .callout)
        button.setTitleColor(.systemBackground, for: .normal)
        button.tintColor = .systemBackground
        button.backgroundColor = .systemTeal
        button.layer.cornerRadius = 12
        button.isHidden = true
        return button
    }()
    
//    public lazy var sideBarIV: UIImageView = {
//        let iv = UIImageView(image: UIImage(systemName: "line.horizontal.3"))
//        iv.tintColor = .systemTeal
//        iv.isUserInteractionEnabled = true
//        return iv
//    }()

    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit(){
        setupMapView()
        //setupSideBarImageView()
        setupSearchbarView()
        setupSearchBarTFConstrainsts()
        setupDateTimeConstrainsts()
        setUpSearchAreaButton()
    }
    
    private func setupMapView(){
        addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
    }
    
//    private func setupSideBarImageView(){
//        addSubview(sideBarIV)
//        sideBarIV.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            sideBarIV.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 4),
//            sideBarIV.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 8),
//            sideBarIV.heightAnchor.constraint(equalTo: mapView.heightAnchor, multiplier: 0.05),
//            sideBarIV.widthAnchor.constraint(equalToConstant: 32)
//        ])
//    }
    
    private func setupSearchbarView(){
        addSubview(searchBarView)
        searchBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBarView.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 4),
            searchBarView.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 48),
            searchBarView.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -48),
            searchBarView.heightAnchor.constraint(equalTo: mapView.heightAnchor, multiplier: 0.05),
        ])
    }
    
    private func setupSearchBarTFConstrainsts(){
        searchBarView.addSubview(searchLabel)
        searchLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchLabel.leadingAnchor.constraint(equalTo: searchBarView.leadingAnchor, constant: 4),
            searchLabel.topAnchor.constraint(equalTo: searchBarView.topAnchor, constant: 4),
            searchLabel.widthAnchor.constraint(equalTo: searchBarView.widthAnchor, multiplier: 0.7),
            searchLabel.bottomAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: -4),
        ])
    }
    
    private func setupDateTimeConstrainsts(){
        searchBarView.addSubview(dateTimeButton)
        dateTimeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateTimeButton.leadingAnchor.constraint(equalTo: searchLabel.trailingAnchor, constant: 4),
            dateTimeButton.topAnchor.constraint(equalTo: searchLabel.topAnchor),
            dateTimeButton.trailingAnchor.constraint(equalTo: searchBarView.trailingAnchor, constant: -4),
            dateTimeButton.bottomAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: -4)
        ])
    }
    
    private func setUpSearchAreaButton(){
        addSubview(searchByMapViewButton)
        searchByMapViewButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchByMapViewButton.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: 8),
            searchByMapViewButton.centerXAnchor.constraint(equalTo: searchBarView.centerXAnchor),
            searchByMapViewButton.widthAnchor.constraint(equalTo: searchBarView.widthAnchor, multiplier: 0.4)
        ])
    }


}
