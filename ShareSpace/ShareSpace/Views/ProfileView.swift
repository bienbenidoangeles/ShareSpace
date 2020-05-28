//
//  ProfileView.swift
//  ShareSpace
//
//  Created by Liubov Kaper  on 5/27/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit

class ProfileView: UIView {
    
    override func layoutSubviews() {
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 3
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.layer.borderColor = UIColor.white.cgColor
    }
    
    public lazy var editProfileButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.systemOrange, for: .normal)
        
        return button
    }()
    
    public lazy var updateProfileButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Update Profile", for: .normal)
        button.setTitleColor(.systemOrange, for: .normal)
        
        return button
    }()

     public lazy var profileImageView: UIImageView = {
            let imageView = UIImageView()
        
        imageView.image = UIImage(systemName: "person.fill")
        imageView.contentMode = .scaleAspectFill
        imageView.layoutSubviews()
        imageView.backgroundColor = .systemOrange

           imageView.tintColor = .systemYellow
        
            return imageView
        }()
    
    //private
    public lazy var editProfileImageButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "camera.circle"), for: .normal)
        //button.setTitleColor(.systemOrange, for: .normal)
        button.tintColor = .systemOrange
        
        return button
    }()
    
    //Do we use this? - now yes
    public lazy var userDisplayNameLabel: UILabel = {
        let label = UILabel()
        label.text = "display name"
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    public lazy var userDisplayNameTextfield: UITextField = {
           let textfield = UITextField()
           textfield.placeholder = "Enter username"
           //textfield.numberOfLines = 1
           textfield.textAlignment = .left
           return textfield
       }()
        
        public lazy var userNameLabel: UILabel = {
            let label = UILabel()
            label.text = "full name"
            label.numberOfLines = 1
            label.textAlignment = .left
            return label
        }()
    
    public lazy var userNameTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter your first and last name"
        textfield.textAlignment = .left
        return textfield
    }()
    
    
    
    public lazy var phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "phone number"
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    public lazy var userPhoneNumberTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter your phone number"
        textfield.textAlignment = .left
        return textfield
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
        label.numberOfLines = 3
        label.textAlignment = .left
        return label
    }()
    
    public lazy var userBioTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Type your bio"
        textfield.textAlignment = .left
        return textfield
    }()
    
    public lazy var occupationLabel: UILabel = {
        let label = UILabel()
        label.text = "Occupation"
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    public lazy var userOccupationTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter your occupation"
        textfield.textAlignment = .left
        return textfield
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
    
    public lazy var userCreditcardTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter your credit ot debit card number"
        textfield.textAlignment = .left
        return textfield
    }()
    
    public lazy var userCreditcardCVVNumberTextfield: UITextField = {
           let textfield = UITextField()
           textfield.placeholder = "Enter your card CVV number"
           textfield.textAlignment = .left
           return textfield
       }()
    
    public lazy var userExpirationDateTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter your card expiration date"
        textfield.textAlignment = .left
        return textfield
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
                setUpEditProfileButtonConstraints()
                
                setUpUpdateProfileButtonConstraints()
                
                setUpProfileImageViewConstraints()
                
                setUpEditProfileImageButtonConstraints()
                
                setUpStackViewConstraints()
                
                setUpStackViewTextFieldConstraints()
                
            }
    
    private func setUpEditProfileButtonConstraints() {
            addSubview(editProfileButton)
            editProfileButton.translatesAutoresizingMaskIntoConstraints =  false
            
            NSLayoutConstraint.activate([
            
                editProfileButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
               editProfileButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            ])
        }
    
    private func setUpUpdateProfileButtonConstraints() {
        addSubview(updateProfileButton)
        updateProfileButton.translatesAutoresizingMaskIntoConstraints =  false
        
        NSLayoutConstraint.activate([
        
            updateProfileButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
           updateProfileButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
        ])
    }
    
    
    
        private func setUpProfileImageViewConstraints() {
            addSubview(profileImageView)
            profileImageView.translatesAutoresizingMaskIntoConstraints =  false
            
            NSLayoutConstraint.activate([
            
                profileImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30),
               // profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
                //profileImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
                profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                profileImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.15),
                profileImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.32)
            ])
        }
    
    private func setUpEditProfileImageButtonConstraints() {
        addSubview(editProfileImageButton)
        editProfileImageButton.translatesAutoresizingMaskIntoConstraints =  false
        
        NSLayoutConstraint.activate([
        
            editProfileImageButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 140),
           editProfileImageButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -140),
        ])
    }
        

        
        private func setUpStackViewConstraints() {
            addSubview(stackView)
            stackView.addArrangedSubview(userDisplayNameLabel)
            stackView.addArrangedSubview(userNameLabel)
            stackView.addArrangedSubview(phoneNumberLabel)
            stackView.addArrangedSubview(emailLabel)
            stackView.addArrangedSubview(bioLabel)
            stackView.addArrangedSubview(occupationLabel)
            stackView.addArrangedSubview(governmentIdLabel)
            stackView.addArrangedSubview(uploadIdButton)
            stackView.addArrangedSubview(paymentLabel)
           // stackView.addArrangedSubview(addPaymentButton)
            
            stackView.translatesAutoresizingMaskIntoConstraints =  false
            
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 50),
                stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
                stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
            ])
        }
    
    private func setUpStackViewTextFieldConstraints() {
        addSubview(stackView)
        stackView.addArrangedSubview(userDisplayNameTextfield)
        stackView.addArrangedSubview(userNameTextfield)
        stackView.addArrangedSubview(userPhoneNumberTextfield)
        stackView.addArrangedSubview(emailLabel)
        stackView.addArrangedSubview(userBioTextfield)
        stackView.addArrangedSubview(userOccupationTextfield)
        stackView.addArrangedSubview(governmentIdLabel)
        stackView.addArrangedSubview(uploadIdButton)
        stackView.addArrangedSubview(userCreditcardTextfield)
        stackView.addArrangedSubview(userCreditcardTextfield)
        stackView.addArrangedSubview(userCreditcardCVVNumberTextfield)
        stackView.addArrangedSubview(userExpirationDateTextfield)
       // stackView.addArrangedSubview(addPaymentButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints =  false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 50),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
        
        
       
        

}
