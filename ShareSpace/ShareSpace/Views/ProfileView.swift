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
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.layer.borderColor = UIColor.black.cgColor
    }
    
    public lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill")
        imageView.contentMode = .scaleAspectFill
        imageView.layoutSubviews()
        imageView.backgroundColor = .yummyOrange
        imageView.tintColor = .sunnyYellow
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = imageView.frame.height/2
        return imageView
    }()
    
    public lazy var editProfileImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "camera.circle"), for: .normal)
        button.tintColor = .yummyOrange
        button.clipsToBounds = true
        return button
    }()
    
    public lazy var userDisplayNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter username:"
        label.textColor = .systemGray
        return label
    }()
    
    public lazy var userDisplayNameTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Username"
        textfield.textAlignment = .left
        return textfield
    }()
    
    public lazy var userFirstNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter your first name"
        label.textColor = .systemGray
        return label
    }()
    
    public lazy var userFirstNameTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "First name"
        textfield.textAlignment = .left
        return textfield
    }()
    
    public lazy var userLastNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter your last name:"
        label.textColor = .systemGray
        return label
    }()
    
    public lazy var userLastNameTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Last name"
        textfield.textAlignment = .left
        return textfield
    }()
    
    public lazy var userLocationLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter your location:"
        label.textColor = .systemGray
        return label
    }()
    
    public lazy var userLocationTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Location"
        textfield.textAlignment = .left
        return textfield
    }()
    
    public lazy var userPhoneLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter your phone number:"
        label.textColor = .systemGray
        return label
    }()
    
    public lazy var userPhoneNumberTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Phone number"
        textfield.textAlignment = .left
        return textfield
    }()
    
    public lazy var emailNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Your email is (not changing):"
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .systemGray
        return label
    }()
    
    public lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    public lazy var userBioLabel: UILabel = {
        let label = UILabel()
        label.text = "Type your bio:"
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .systemGray
        return label
    }()
    
    public lazy var userBioTextview: UITextView = {
        let textview = UITextView()
        textview.textAlignment = .left
        textview.font = .preferredFont(forTextStyle: .body)
        textview.isScrollEnabled = true
        return textview
    }()
    
    public lazy var userOccupationLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter your occupation:"
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .systemGray
        return label
    }()
    
    public lazy var userOccupationTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Occupation"
        textfield.textAlignment = .left
        return textfield
    }()
    
    public lazy var governmentIdLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter government ID name and number:"
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .systemGray
        return label
    }()
    
    public lazy var governmentIdNameTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Government ID name"
        textfield.textAlignment = .left
        return textfield
    }()
    
    public lazy var usercardLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter your credit ot debit card information:"
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .systemGray
        return label
    }()
    
    public lazy var userCreditcardTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Card number"
        textfield.textAlignment = .left
        textfield.keyboardType = .numbersAndPunctuation
        return textfield
    }()
    
    public lazy var userCreditcardCVVNumberTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "CVV number"
        textfield.textAlignment = .left
        textfield.keyboardType = .numbersAndPunctuation
        
        return textfield
    }()
    
    public lazy var userExpirationDateTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Card expiration date"
        textfield.textAlignment = .left
        textfield.keyboardType = .numbersAndPunctuation
        return textfield
    }()
    
    public lazy var saveChangesButton: UIButton = {
        let button = UIButton()
        button.setTitle("  Save  ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .yummyOrange
        button.clipsToBounds = true
        button.layer.cornerRadius = 7
        button.layer.borderColor = UIColor.black.cgColor
        return button
    }()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
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
        stackView.addArrangedSubview(userDisplayNameLabel)
        stackView.addArrangedSubview(userDisplayNameTextfield)
        stackView.addArrangedSubview(userFirstNameLabel)
        stackView.addArrangedSubview(userFirstNameTextfield)
        stackView.addArrangedSubview(userLastNameLabel)
        stackView.addArrangedSubview(userLastNameTextfield)
        stackView.addArrangedSubview(userLocationLabel)
        stackView.addArrangedSubview(userLocationTextfield)
        stackView.addArrangedSubview(userPhoneLabel)
        stackView.addArrangedSubview(userPhoneNumberTextfield)
        stackView.addArrangedSubview(emailNameLabel)
        stackView.addArrangedSubview(emailLabel)
        stackView.addArrangedSubview(userBioLabel)
        stackView.addArrangedSubview(userBioTextview)
        stackView.addArrangedSubview(userOccupationLabel)
        stackView.addArrangedSubview(userOccupationTextfield)
        stackView.addArrangedSubview(governmentIdLabel)
        stackView.addArrangedSubview(governmentIdNameTextfield)
        stackView.addArrangedSubview(usercardLabel)
        stackView.addArrangedSubview(userCreditcardTextfield)
        stackView.addArrangedSubview(userCreditcardCVVNumberTextfield)
        stackView.addArrangedSubview(userExpirationDateTextfield)
        
        stackView.translatesAutoresizingMaskIntoConstraints =  false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            userBioTextview.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setUpSaveChangesButtonConstraints() {
        containerView.addSubview(saveChangesButton)
        saveChangesButton.translatesAutoresizingMaskIntoConstraints =  false
        
        NSLayoutConstraint.activate([
            saveChangesButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 40),
            saveChangesButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            saveChangesButton.widthAnchor.constraint(equalToConstant: 370),
            saveChangesButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -275)
        ])
    }
}
