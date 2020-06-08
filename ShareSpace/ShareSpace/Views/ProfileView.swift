//
//  ProfileView.swift
//  ShareSpace
//
//  Created by Liubov Kaper  on 5/27/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit

class ProfileView: UIView {
    
        public lazy var scrollView: UIScrollView = {
            let scrollView = UIScrollView()
            scrollView.backgroundColor = .white
            scrollView.frame = self.bounds
            scrollView.showsHorizontalScrollIndicator = true
            scrollView.bounces = true
            return scrollView
        }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    override func layoutSubviews() {
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 3
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.layer.borderColor = UIColor.white.cgColor
    }
    
    public lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill")
        imageView.contentMode = .scaleAspectFill
        imageView.layoutSubviews()
        imageView.backgroundColor = .systemOrange
        imageView.tintColor = .systemYellow
        imageView.clipsToBounds = true
        return imageView
    }()
    
    public lazy var editProfileImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "camera.circle"), for: .normal)
        button.tintColor = .systemOrange
        return button
    }()
    
    public lazy var userDisplayNameTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter username"
        textfield.textAlignment = .left
        return textfield
    }()
    
    public lazy var userFirstNameTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter your first name"
        textfield.textAlignment = .left
        return textfield
    }()
    
    public lazy var userLastNameTextfield: UITextField = {
           let textfield = UITextField()
           textfield.placeholder = "Enter your last name"
           textfield.textAlignment = .left
           return textfield
       }()
    
    //FIXME: change for segmented control?
    public lazy var userTypeTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Host or Renter"
        textfield.textAlignment = .left
        return textfield
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
    
    public lazy var userBioTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Type your bio"
        textfield.textAlignment = .left
        return textfield
    }()
    
    public lazy var userOccupationTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter your occupation"
        textfield.textAlignment = .left
        return textfield
    }()
    
    public lazy var governmentIdTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter government ID name and number"
        textfield.textAlignment = .left
        return textfield
    }()
    
    //Should be nil if host!
    public lazy var userCreditcardTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter your credit ot debit card number"
        textfield.textAlignment = .left
        return textfield
    }()
    
     //Should be nil if host!
    public lazy var userCreditcardCVVNumberTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter your card CVV number"
        textfield.textAlignment = .left
        return textfield
    }()
    
     //Should be nil if host!
    public lazy var userExpirationDateTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter your card expiration date"
        textfield.textAlignment = .left
        return textfield
    }()
    
    public lazy var uploadIdButton: UIButton = {
        let button = UIButton()
        button.setTitle("Upload ID", for: .normal)
        button.setTitleColor(.systemOrange, for: .normal)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    
    //Should be nil if host?
    public lazy var idImageView: UIImageView = {
        let imageView = UIImageView()
        //imageView.image = UIImage(systemName: "person.fill")
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray3
        return imageView
    }()
    
    public lazy var saveChangesButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
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
        setUpScrollviewConstraints()
        setUpContainerviewConstraints()
        setUpProfileImageViewConstraints()
        setUpEditProfileImageButtonConstraints()
        setUpStackViewTextFieldConstraints()
        setUpSaveChangesButtonConstraints()
    }
    
        private func setUpScrollviewConstraints() {
            addSubview(scrollView)
            
            scrollView.translatesAutoresizingMaskIntoConstraints =  false
    
            NSLayoutConstraint.activate([
                scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
                scrollView.topAnchor.constraint(equalTo: topAnchor),
                scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
    
    private func setUpContainerviewConstraints() {
        scrollView.addSubview(containerView)

            containerView.translatesAutoresizingMaskIntoConstraints =  false
        
        let heightConstraint = containerView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        heightConstraint.priority = UILayoutPriority(250)

            NSLayoutConstraint.activate([
                containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                heightConstraint
            ])
        }
    
    private func setUpProfileImageViewConstraints() {
        containerView.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints =  false
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
           profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            profileImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.15),
            profileImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.32)
        ])
    }
    
    private func setUpEditProfileImageButtonConstraints() {
        containerView.addSubview(editProfileImageButton)
        editProfileImageButton.translatesAutoresizingMaskIntoConstraints =  false
        
        NSLayoutConstraint.activate([
            editProfileImageButton.topAnchor.constraint(equalTo:  containerView.topAnchor, constant: 130),
            editProfileImageButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -157),
        ])
    }
    
    private func setUpStackViewTextFieldConstraints() {
        containerView.addSubview(stackView)
        stackView.addArrangedSubview(userDisplayNameTextfield)
        stackView.addArrangedSubview(userFirstNameTextfield)
        stackView.addArrangedSubview(userLastNameTextfield)
        stackView.addArrangedSubview(userTypeTextfield)
        stackView.addArrangedSubview(userPhoneNumberTextfield)
        stackView.addArrangedSubview(emailLabel)
        stackView.addArrangedSubview(userBioTextfield)
        stackView.addArrangedSubview(userOccupationTextfield)
        stackView.addArrangedSubview(governmentIdTextfield)
        stackView.addArrangedSubview(uploadIdButton)
        stackView.addArrangedSubview(idImageView)
        stackView.addArrangedSubview(userCreditcardTextfield)
        stackView.addArrangedSubview(userCreditcardTextfield)
        stackView.addArrangedSubview(userCreditcardCVVNumberTextfield)
        stackView.addArrangedSubview(userExpirationDateTextfield)
        
        stackView.translatesAutoresizingMaskIntoConstraints =  false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    private func setUpSaveChangesButtonConstraints() {
        containerView.addSubview(saveChangesButton)
        saveChangesButton.translatesAutoresizingMaskIntoConstraints =  false
        
        NSLayoutConstraint.activate([
            saveChangesButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8),
            saveChangesButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            saveChangesButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -275)
        ])
    }
}
