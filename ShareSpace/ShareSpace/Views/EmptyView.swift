//
//  EmptyView.swift
//  ShareSpace
//
//  Created by Bienbenido Angeles on 6/23/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit

class EmptyView: UIView {
    
    // title and a messege
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "Empty State"
        return label
        
    }()
    
    public lazy var messegeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 4
        label.textAlignment = .center
        label.text = "t"
        return label
    }()

//    override init(frame: CGRect) {
//        super.init(frame: UIScreen.main.bounds)
//        commonInit()
//    }
    init(title:String, messege: String) {
        super.init(frame: UIScreen.main.bounds)
        titleLabel.text = title
        messegeLabel.text = messege
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setUpMessegeLabelConstraints()
        setUpTitleLabelConstraints()
    }
    
    private func setUpMessegeLabelConstraints() {
        addSubview(messegeLabel)
        messegeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messegeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messegeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            messegeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            messegeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
    
    private func setUpTitleLabelConstraints() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: messegeLabel.topAnchor, constant: -8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
            
        ])
    }


}
