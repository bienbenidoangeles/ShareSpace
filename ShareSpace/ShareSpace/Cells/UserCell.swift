//
//  UserCell.swift
//  ShareSpace
//
//  Created by Eric Davenport on 6/3/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit
import Firebase

class UserCell: UITableViewCell {
  
//  override func layoutSubviews() {
//    backViewSubview()
//  }
  
  public lazy var cellBackgroundView: UIView = {
    let view = UIView()
    view.backgroundColor = .systemPurple
    return view
  }()
  
  public lazy var userImageView: UIImageView = {
    let iv = UIImageView()
    iv.image = UIImage(systemName: "photo.fill")
    return iv
  }()

  public lazy var nameLabel: UILabel = {
    let label = UILabel()
    label.backgroundColor = .white
    label.text = "Name Label"
    label.font = .preferredFont(forTextStyle: .headline)
    return label
  }()
  
  public lazy var dateLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .footnote)
    label.text = "date label"
    label.font = label.font.withSize(10)
    return label
  }()
  
  public lazy var textSnapshot: UILabel = {
    let label = UILabel()
    label.text = "Message Snapshot"
    label.font = .preferredFont(forTextStyle: .subheadline)
    return label
  }()
  
  public lazy var moreButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
    return button
  }()
  
  
   override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
     super.init(style: style, reuseIdentifier: reuseIdentifier)
     commonInit()
   }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }
  
  private func commonInit() {
    imageViewConstrainst()
    constaintNameLabel()
    constaintTextSnapshot()
    constraintMoreButton()
    constraintDateLabel()
//    constraintBackgroundView()
  }

  

  
  private func constraintBackgroundView() {
    addSubview(cellBackgroundView)
    cellBackgroundView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      cellBackgroundView.topAnchor.constraint(equalTo: topAnchor, constant: 50),
      cellBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
      cellBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
      cellBackgroundView.bottomAnchor.constraint(equalTo: topAnchor, constant: -50)
    ])
  }
  
  private func constaintNameLabel() {
    addSubview(nameLabel)
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
    
      nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
      nameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 8),
      nameLabel.widthAnchor.constraint(equalToConstant: 130)
    ])
  }
  
  private func imageViewConstrainst() {
    addSubview(userImageView)
    userImageView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      userImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      userImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
      userImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
      userImageView.widthAnchor.constraint(equalTo: userImageView.heightAnchor)
    ])
  }
  
  private func constaintTextSnapshot() {
    addSubview(textSnapshot)
    textSnapshot.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
    
      textSnapshot.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
      textSnapshot.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 8),
      textSnapshot.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
    ])
  }
  
  private func constraintMoreButton() {
    addSubview(moreButton)
    moreButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      moreButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      moreButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
      moreButton.widthAnchor.constraint(equalToConstant: 44)
    ])
  }
  
  private func constraintDateLabel() {
    addSubview(dateLabel)
    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
      dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
      dateLabel.topAnchor.constraint(equalTo: textSnapshot.bottomAnchor, constant: 2),
      dateLabel.widthAnchor.constraint(equalToConstant: 65)
    ])
  }
  
  
  

}


extension UserCell {
  private func backViewSubview() {
    cellBackgroundView.layer.borderWidth = 3
    cellBackgroundView.layer.cornerRadius = cellBackgroundView.frame.height / 2
    cellBackgroundView.layer.borderColor = UIColor.black.cgColor
  }
  
  func configureCell(_ chat: Chat, userIDs: [String]) {
    var ids = userIDs
    guard let currentUser = Auth.auth().currentUser else { return }
    for (index, i) in ids.enumerated() {
      if i == currentUser.uid {
        
        ids.remove(at: index)
      }
    }
    
    DatabaseService.shared.loadUser(userId: ids[0]) { (result) in
      switch result {
      case .failure(let error):
        print("Error loading user: \(error)")
      case .success(let user):
        self.nameLabel.text = user.userEmail
//        userImageView.image
      }
    }
    
    nameLabel.text = "user id: \(chat.users.description)"
  }
  
  
}

