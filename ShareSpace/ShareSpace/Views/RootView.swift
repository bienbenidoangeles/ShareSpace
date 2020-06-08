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
    
    public lazy var searchTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "I want to go to..."
        tf.borderStyle = .none
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
        setupSearchbarView()
        setupSearchBarTFConstrainsts()
        setupDateTimeConstrainsts()
    }
    
    private func setupMapView(){
        addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
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
        searchBarView.addSubview(searchTextField)
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchTextField.leadingAnchor.constraint(equalTo: searchBarView.leadingAnchor, constant: 4),
            searchTextField.topAnchor.constraint(equalTo: searchBarView.topAnchor, constant: 4),
            searchTextField.widthAnchor.constraint(equalTo: searchBarView.widthAnchor, multiplier: 0.7),
            searchTextField.bottomAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: -4),
        ])
    }
    
    private func setupDateTimeConstrainsts(){
        searchBarView.addSubview(dateTimeButton)
        dateTimeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateTimeButton.leadingAnchor.constraint(equalTo: searchTextField.trailingAnchor, constant: 4),
            dateTimeButton.topAnchor.constraint(equalTo: searchTextField.topAnchor),
            dateTimeButton.trailingAnchor.constraint(equalTo: searchBarView.trailingAnchor, constant: -4),
            dateTimeButton.bottomAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: -4)
        ])
    }


}
