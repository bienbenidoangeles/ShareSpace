//
//  SideBarView.swift
//  ShareSpace
//
//  Created by Bienbenido Angeles on 6/23/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit

class SideBarView: UIView {
    
//    public lazy var sideBarIV: UIImageView = {
//        let iv = UIImageView(image: UIImage(systemName: "xmark"))
//        iv.tintColor = .systemOrange
//        iv.isUserInteractionEnabled = true
//        return iv
//    }()
    
    public lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Login"
        label.isUserInteractionEnabled = true
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .title2)
        return label
    }()
    
    public lazy var chatLabel: UILabel = {
        let label = UILabel()
        label.text = "Chat"
        return label
    }()
    
    public lazy var myProfileLabel: UILabel = {
        let label = UILabel()
        label.text = "My Collections"
        return label
    }()
    
    public lazy var settingsLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        return label
    }()
    
    private lazy var coreLabels: [UILabel] = {
        let labels:[UILabel] = [chatLabel, myProfileLabel, settingsLabel]
        for label in labels{
            label.isUserInteractionEnabled = true
            label.textAlignment = .center
            label.font = .preferredFont(forTextStyle: .largeTitle)
        }
        return labels
    }()
    
    public lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: coreLabels)
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 4
        return stackView
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
//        setupSideBarImageView()
        setupStackView()
        setupLoginLabel()
        
    }
    
//    private func setupSideBarImageView(){
//        addSubview(sideBarIV)
//        sideBarIV.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            sideBarIV.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 4),
//            sideBarIV.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
//            sideBarIV.heightAnchor.constraint(equalTo: sideBarIV.widthAnchor),
//            sideBarIV.widthAnchor.constraint(equalToConstant: 32)
//        ])
//    }
    
    private func setupLoginLabel(){
        addSubview(loginLabel)
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            loginLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            loginLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            loginLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 32)
        ])
    }
    
    private func setupStackView(){
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    
}
