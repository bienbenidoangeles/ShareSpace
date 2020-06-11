//
//  SearchResultsView.swift
//  ShareSpace
//
//  Created by Bienbenido Angeles on 6/11/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit

class SearchResultsView: UIView {
    
    public lazy var searchBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemOrange
        view.layer.cornerRadius = 12
        //view.layoutSubviews()
        return view
    }()
    
    public lazy var searchTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "I want to go to..."
        tf.borderStyle = .none
        tf.textColor = .systemBackground
        tf.layer.cornerRadius = 12
        return tf
    }()
    
    public lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        return tableView
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
        setupSearchbarView()
        setupSearchBarTFConstrainsts()
        setupTableViewConstrainsts()
    }
    
    private func setupSearchbarView(){
        addSubview(searchBarView)
        searchBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBarView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 4),
            searchBarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 48),
            searchBarView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -48),
            searchBarView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.05),
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
    
    private func setupTableViewConstrainsts(){
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: 8),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    

}
