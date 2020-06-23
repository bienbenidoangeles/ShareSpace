//
//  ReservationDetailView.swift
//  ShareSpace
//
//  Created by Liubov Kaper  on 6/13/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit

class ReservationDetailView: UIView {
    
    
    
    public lazy var reservationStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "status"
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.backgroundColor = .systemGroupedBackground
        return label
    }()
    
    lazy var userInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGroupedBackground
        return view
    }()
    
    public lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Full Name"
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    public lazy var userLocationLabel: UILabel = {
        let label = UILabel()
        label.text = "Lives in:"
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    public lazy var userRatingLabel: UILabel = {
        let label = UILabel()
        label.text = "Reviews:"
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    public lazy var viewProfileButton: UIButton = {
        let button = UIButton()
        button.setTitle("View Profile", for: .normal)
        button.setTitleColor(.oceanBlue, for: .normal)
        //button.addTarget(self, action: #selector(viewProfileButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    
    
    override func layoutSubviews() {
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 3
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.layer.borderColor = UIColor.white.cgColor
        acceptButton.clipsToBounds = true
        acceptButton.layer.cornerRadius = 13
        declineButton.clipsToBounds = true
        declineButton.layer.cornerRadius = 13
    }
    
    public lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill")
        imageView.contentMode = .scaleAspectFill
        imageView.layoutSubviews()
       // imageView.backgroundColor = .yummyOrange
        imageView.tintColor = .sunnyYellow
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // POST DETAILS VIEW
    
    lazy var postInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGroupedBackground
        return view
    }()
    
    public lazy var postTitelLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    public lazy var postDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 3
        label.textAlignment = .left
        return label
    }()
    
    public lazy var postLocationLabel: UILabel = {
        let label = UILabel()
        label.text = "Location"
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    public lazy var viewPostButton: UIButton = {
        let button = UIButton()
        button.setTitle("View Post", for: .normal)
        button.setTitleColor(.oceanBlue, for: .normal)
        return button
    }()
    
    // Reservation DETAILS VIEW
    
    lazy var reservationDetailsView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGroupedBackground
        return view
    }()
    
    public lazy var checkInDateLabel: UILabel = {
        let label = UILabel()
        label.text = "CheckIn"
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    public lazy var checkOutDateLabel: UILabel = {
        let label = UILabel()
        label.text = "CheckOut"
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    public lazy var checkInTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "CheckInTime"
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    public lazy var checkOutTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "CheckOutTime"
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    public lazy var numberOfGuestsLabel: UILabel = {
        let label = UILabel()
        label.text = "Number of Guests"
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    // Accept/Decline buttons VIEW
    
    lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        stackView.axis = .horizontal
        stackView.backgroundColor = .systemGroupedBackground
        return stackView
    }()
    
    public lazy var acceptButton: UIButton = {
        let button = UIButton()
        button.setTitle("ACCEPT", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .yummyOrange
        return button
    }()
    
    public lazy var declineButton: UIButton = {
        let button = UIButton()
        button.setTitle("DECLINE", for: .normal)
        button.setTitleColor(.yummyOrange, for: .normal)
        button.backgroundColor = .systemGroupedBackground
        return button
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
        setupReservationStatusLabelConstraints()
        setupUserInfoViewConstraints()
        setupUserNameLabelConstraints()
        setupUserLocationLabelConstraints()
        setupUserRatingLabelConstraints()
        setupViewProfileButtonConstraints()
        setupProfileImageConstraints()
        setupPostInfoViewConstraints()
        setupPostTitleLabelConstraints()
        setupPostDescriptionLabelConstraints()
        setupPostLocationLabelConstraints()
        setupViewPostButtonConstraints()
        setupReservationDetailsViewConstraints()
        setupCheckinDateLabelConstraints()
        setupCheckOutDateLabelConstraints()
        setupCheckInTimeLabelConstraints()
        setupCheckOutTimeLabelConstraints()
        setupNumberOfGuestsLabelConstraints()
        setupButtonsStackViewConstraints()
    }
    
    private func setupReservationStatusLabelConstraints() {
        addSubview(reservationStatusLabel)
        reservationStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            reservationStatusLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            reservationStatusLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            reservationStatusLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    private func setupUserInfoViewConstraints() {
        addSubview(userInfoView)
        userInfoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userInfoView.topAnchor.constraint(equalTo: reservationStatusLabel.bottomAnchor, constant: 16),
            userInfoView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            userInfoView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            userInfoView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.20)
        ])
    }
    
    private func setupUserNameLabelConstraints() {
        userInfoView.addSubview(userNameLabel)
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: userInfoView.topAnchor, constant: 8),
            userNameLabel.leadingAnchor.constraint(equalTo: userInfoView.leadingAnchor, constant: 8),
            userNameLabel.widthAnchor.constraint(equalTo: userInfoView.widthAnchor, multiplier: 0.50)
        ])
    }
    
    private func setupUserLocationLabelConstraints() {
        userInfoView.addSubview(userLocationLabel)
        userLocationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userLocationLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8),
            userLocationLabel.leadingAnchor.constraint(equalTo: userInfoView.leadingAnchor, constant: 8),
            userLocationLabel.widthAnchor.constraint(equalTo: userInfoView.widthAnchor, multiplier: 0.50)
        ])
    }

    private func setupUserRatingLabelConstraints() {
        userInfoView.addSubview(userRatingLabel)
        userRatingLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userRatingLabel.topAnchor.constraint(equalTo: userLocationLabel.bottomAnchor, constant: 8),
            userRatingLabel.leadingAnchor.constraint(equalTo: userInfoView.leadingAnchor, constant: 8),
            userRatingLabel.widthAnchor.constraint(equalTo: userInfoView.widthAnchor, multiplier: 0.50)
        ])
    }
    private func setupViewProfileButtonConstraints() {
        userInfoView.addSubview(viewProfileButton)
       viewProfileButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewProfileButton.bottomAnchor.constraint(equalTo: userInfoView.bottomAnchor, constant: -5),
            viewProfileButton.centerXAnchor.constraint(equalTo: userInfoView.centerXAnchor)
        ])
    }
    private func setupProfileImageConstraints() {
        userInfoView.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: userInfoView.topAnchor, constant: 20),
            profileImageView.trailingAnchor.constraint(equalTo: userInfoView.trailingAnchor, constant: -8),
            profileImageView.heightAnchor.constraint(equalTo: userInfoView.heightAnchor, multiplier: 0.53),
            profileImageView.widthAnchor.constraint(equalTo: userInfoView.widthAnchor, multiplier: 0.25)
        ])
    }
    
    
    private func setupPostInfoViewConstraints() {
        addSubview(postInfoView)
        postInfoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postInfoView.topAnchor.constraint(equalTo: userInfoView.bottomAnchor, constant: 16),
            postInfoView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            postInfoView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            postInfoView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.20)
        ])
    }
    
    private func setupPostTitleLabelConstraints() {
        postInfoView.addSubview(postTitelLabel)
        postTitelLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postTitelLabel.topAnchor.constraint(equalTo: postInfoView.topAnchor, constant: 8),
            postTitelLabel.leadingAnchor.constraint(equalTo: postInfoView.leadingAnchor, constant: 8),
            postTitelLabel.trailingAnchor.constraint(equalTo: postInfoView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupPostDescriptionLabelConstraints() {
        postInfoView.addSubview(postDescriptionLabel)
        postDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postDescriptionLabel.topAnchor.constraint(equalTo: postTitelLabel.bottomAnchor, constant: 8),
            postDescriptionLabel.leadingAnchor.constraint(equalTo: postInfoView.leadingAnchor, constant: 8),
            postDescriptionLabel.trailingAnchor.constraint(equalTo: postInfoView.trailingAnchor, constant: -16),
            postDescriptionLabel.heightAnchor.constraint(equalTo: postInfoView.heightAnchor, multiplier: 0.40)
        ])
    }
    
    private func setupPostLocationLabelConstraints() {
        postInfoView.addSubview(postLocationLabel)
        postLocationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postLocationLabel.topAnchor.constraint(equalTo: postDescriptionLabel.bottomAnchor, constant: 8),
            postLocationLabel.leadingAnchor.constraint(equalTo: postInfoView.leadingAnchor, constant: 8),
            postLocationLabel.trailingAnchor.constraint(equalTo: postInfoView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupViewPostButtonConstraints() {
        postInfoView.addSubview(viewPostButton)
        viewPostButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewPostButton.bottomAnchor.constraint(equalTo: postInfoView.bottomAnchor, constant: -5),
            viewPostButton.centerXAnchor.constraint(equalTo: postInfoView.centerXAnchor)
        ])
    }
    private func setupReservationDetailsViewConstraints() {
        addSubview(reservationDetailsView)
        reservationDetailsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            reservationDetailsView.topAnchor.constraint(equalTo: postInfoView.bottomAnchor, constant: 16),
            reservationDetailsView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            reservationDetailsView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            reservationDetailsView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.20)
        ])
    }
    
    private func setupCheckinDateLabelConstraints() {
        reservationDetailsView.addSubview(checkInDateLabel)
        checkInDateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkInDateLabel.topAnchor.constraint(equalTo: reservationDetailsView.topAnchor, constant: 8),
            checkInDateLabel.leadingAnchor.constraint(equalTo:  reservationDetailsView.leadingAnchor, constant: 16),
            checkInDateLabel.trailingAnchor.constraint(equalTo: reservationDetailsView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupCheckOutDateLabelConstraints() {
        reservationDetailsView.addSubview(checkOutDateLabel)
        checkOutDateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkOutDateLabel.topAnchor.constraint(equalTo: checkInDateLabel.bottomAnchor, constant: 16),
            checkOutDateLabel.leadingAnchor.constraint(equalTo:  reservationDetailsView.leadingAnchor, constant: 16),
            checkOutDateLabel.trailingAnchor.constraint(equalTo: reservationDetailsView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupCheckInTimeLabelConstraints() {
        reservationDetailsView.addSubview(checkInTimeLabel)
        checkInTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkInTimeLabel.topAnchor.constraint(equalTo: checkOutDateLabel.bottomAnchor, constant: 16),
            checkInTimeLabel.leadingAnchor.constraint(equalTo:  reservationDetailsView.leadingAnchor, constant: 16),
            checkInTimeLabel.trailingAnchor.constraint(equalTo: reservationDetailsView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupCheckOutTimeLabelConstraints() {
        reservationDetailsView.addSubview(checkOutTimeLabel)
        checkOutTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkOutTimeLabel.topAnchor.constraint(equalTo: checkInTimeLabel.bottomAnchor, constant: 16),
            checkOutTimeLabel.leadingAnchor.constraint(equalTo:  reservationDetailsView.leadingAnchor, constant: 16),
            checkOutTimeLabel.trailingAnchor.constraint(equalTo: reservationDetailsView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupNumberOfGuestsLabelConstraints() {
        reservationDetailsView.addSubview(numberOfGuestsLabel)
        numberOfGuestsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            numberOfGuestsLabel.bottomAnchor.constraint(equalTo: reservationDetailsView.bottomAnchor, constant: -8),
            numberOfGuestsLabel.leadingAnchor.constraint(equalTo:  reservationDetailsView.leadingAnchor, constant: 16),
            numberOfGuestsLabel.trailingAnchor.constraint(equalTo: reservationDetailsView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupButtonsStackViewConstraints() {
        addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(acceptButton)
        buttonsStackView.addArrangedSubview(declineButton)
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            buttonsStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8),
            buttonsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            buttonsStackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.07)
            
        ])
    }
}
