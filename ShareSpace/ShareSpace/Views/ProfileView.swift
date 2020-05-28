//
//  ProfileView.swift
//  ShareSpace
//
//  Created by Liubov Kaper  on 5/27/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit

class ProfileView: UIView {

     public lazy var profileImageView: UIImageView = {
          //  let imageView = UIImageView()
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 125, height: 125))
        imageView.image = UIImage(systemName: "person.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.layoutSubviews()
        imageView.backgroundColor = .systemOrange
//        imageView.layer.cornerRadius = imageView.frame.height / 2
//        imageView.image = UIImage(systemName: "person.fill")
//            imageView.contentMode = .scaleAspectFit
//            imageView.clipsToBounds =  true
//            imageView.tintColor = .systemOrange
        
            return imageView
        }()
    
    public lazy var userDisplayNameLabel: UILabel = {
        let label = UILabel()
        label.text = "display name"
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
        
        public lazy var userNameLabel: UILabel = {
            let label = UILabel()
            label.text = "full name"
            label.numberOfLines = 1
            label.textAlignment = .left
            return label
        }()
    
    
    
    public lazy var phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "phone number"
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
        
        public lazy var emailLabel: UILabel = {
            let label = UILabel()
            label.text = "email"
            label.numberOfLines = 1
            label.textAlignment = .left
            return label
        }()
    
    public lazy var bioLabel: UILabel = {
        let label = UILabel()
        label.text = "bio"
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    public lazy var occupationLabel: UILabel = {
        let label = UILabel()
        label.text = "Occupation"
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    public lazy var governmentIdLabel: UILabel = {
        let label = UILabel()
        label.text = "Government ID"
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    public lazy var paymentLabel: UILabel = {
        let label = UILabel()
        label.text = "Payment method"
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
        
        
        private lazy var uploadIdButton: UIButton = {
            let button = UIButton()
            
            button.setTitle("Upload ID", for: .normal)
            button.setTitleColor(.systemOrange, for: .normal)
            
            return button
        }()
    
        private lazy var addPaymentButton: UIButton = {
            let button = UIButton()
            button.setTitle("Add payment method", for: .normal)
            button.setTitleColor(.systemOrange, for: .normal)
            return button
        }()
        
    
        
        private var stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.distribution = .fillEqually
            stackView.spacing = 5
            stackView.axis = .vertical
            stackView.backgroundColor = .systemYellow
            return stackView
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
                setUpProfileImageViewConstraints()
                
                setUpStackViewConstraints()
                
            }
        
        private func setUpProfileImageViewConstraints() {
            addSubview(profileImageView)
            profileImageView.translatesAutoresizingMaskIntoConstraints =  false
            
            NSLayoutConstraint.activate([
            
                profileImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30),
                profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
                profileImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
                profileImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.15)
            
            
            ])
        }
        

        
        private func setUpStackViewConstraints() {
            addSubview(stackView)
            stackView.addArrangedSubview(userNameLabel)
            stackView.addArrangedSubview(phoneNumberLabel)
            stackView.addArrangedSubview(emailLabel)
            stackView.addArrangedSubview(bioLabel)
            stackView.addArrangedSubview(occupationLabel)
            stackView.addArrangedSubview(governmentIdLabel)
            stackView.addArrangedSubview(uploadIdButton)
            stackView.addArrangedSubview(paymentLabel)
            stackView.addArrangedSubview(addPaymentButton)
            
            stackView.translatesAutoresizingMaskIntoConstraints =  false
            
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 50),
                stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
                stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
               // stackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.04)
            
            ])
        }
        
        
       
        

}
