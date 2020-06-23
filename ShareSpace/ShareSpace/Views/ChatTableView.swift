//
//  ChatTabeView.swift
//  ShareSpace
//
//  Created by Eric Davenport on 6/15/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit
import Firebase

//protocol SendMessageDelegate: AnyObject {
//  func didSendMessage_(
//}

class ChatTableView: UIView {
  
  public var chatId: String?
  
  var controller: UIViewController?
  var reservationId: String?
  var hostId: String?
  
  public lazy var headerView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    return view
  }()
  
  public lazy var detailsButton: UIButton = {
    let button = UIButton()
    button.setTitle("Details", for: .normal)
    button.setTitleColor(.orange, for: .normal)
    button.isUserInteractionEnabled = true
    button.addTarget(self, action: #selector(loadDetailsPage), for: .touchUpInside)
    return button
  }()
  
  public lazy var userProfileImageView: UIImageView = {
    let iv = UIImageView()
    iv.image = UIImage(systemName: "photo.fill")
    return iv
  }()
  
  public lazy var statusLabel: UILabel = {
    let label = UILabel()
    label.text = " STATUS "
    label.font = .preferredFont(forTextStyle: .headline)
    label.backgroundColor = .systemGreen
    return label
  }()
  
  public lazy var tableView: UITableView = {
    let tv = UITableView()
    tv.backgroundColor = .systemGroupedBackground
    tv.separatorStyle = .none
    return tv
  }()
  
  public lazy var statusStackView: UIStackView = {
    let sv = UIStackView()
    sv.axis = .horizontal
    sv.alignment = .fill
    sv.distribution = .fillEqually
    sv.spacing = 0
    sv.backgroundColor = .systemGreen
    return sv
  }()
  
  public lazy var leftStatusView: UIView = {
    let view = UIView()
    view.backgroundColor = .systemGreen
    return view
  }()
  
  public lazy var rightStatusView: UIView = {
    let view = UIView()
    view.backgroundColor = .systemGreen
    return view
  }()
  
  public lazy var messageField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "enter message"
    tf.backgroundColor = .white
    return tf
  }()
  
  public lazy var sendButton: UIButton = {
    let button = UIButton()
    button.setTitle("Send", for: .normal)
    button.backgroundColor = .purple
    button.isUserInteractionEnabled = true
    button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
    return button
  }()
  
  public lazy var messageStack: UIStackView = {
    let sv = UIStackView()
    sv.axis = .horizontal
    sv.spacing = 4
    //    sv.distribution = .fillEqually
    sv.alignment = .fill
    //    sv.backgroundColor = .white
    return sv
  }()
  
  
  
  override init(frame: CGRect) {
    super.init(frame: UIScreen.main.bounds)
    commonInit()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }
  
  private func commonInit() {
    constraintLayout()
  }
  
  private func tableViewContraints() {
    addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
      tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: messageStack.topAnchor)
    ])
  }
  
  private func headerViewConstraints() {
    addSubview(headerView)
    headerView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      headerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
      headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
      headerView.heightAnchor.constraint(equalToConstant: 65)
    ])
  }
  
  private func detailButtonConstraints() {
    headerView.addSubview(detailsButton)
    detailsButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      detailsButton.trailingAnchor.constraint(equalTo: trailingAnchor),
      detailsButton.widthAnchor.constraint(equalToConstant: 65),
      detailsButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: 4)
    ])
  }
  
  private func imageViewConstraints() {
    headerView.addSubview(userProfileImageView)
    userProfileImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      userProfileImageView.heightAnchor.constraint(equalTo: headerView.heightAnchor, multiplier: 0.65),
      userProfileImageView.widthAnchor.constraint(equalTo: userProfileImageView.heightAnchor),
      userProfileImageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
      userProfileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4)
    ])
  }
  
  
  
  private func statusStackConstraints() {
    headerView.addSubview(statusStackView)
    statusStackView.translatesAutoresizingMaskIntoConstraints = false
    statusStackView.addArrangedSubview(leftStatusView)
    leftStatusView.translatesAutoresizingMaskIntoConstraints = false
    statusStackView.addArrangedSubview(statusLabel)
    statusLabel.translatesAutoresizingMaskIntoConstraints = false
    statusStackView.addArrangedSubview(rightStatusView)
    rightStatusView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      statusStackView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
      statusStackView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
    ])
  }
  
  private func messageStackConstraints() {
    addSubview(messageStack)
    messageStack.translatesAutoresizingMaskIntoConstraints = false
    messageStack.addArrangedSubview(messageField)
    messageField.translatesAutoresizingMaskIntoConstraints = false
    messageStack.addArrangedSubview(sendButton)
    sendButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      messageStack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
      messageStack.leadingAnchor.constraint(equalTo: leadingAnchor),
      messageStack.trailingAnchor.constraint(equalTo: trailingAnchor),
      messageStack.heightAnchor.constraint(equalToConstant: 45),
      sendButton.heightAnchor.constraint(equalToConstant: 35)
    ])
  }
  
  private func messageFieldConstraints() {
    addSubview(messageField)
    messageField.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      messageField.topAnchor.constraint(equalTo: tableView.bottomAnchor),
      messageField.leadingAnchor.constraint(equalTo: leadingAnchor),
      messageField.trailingAnchor.constraint(equalTo: trailingAnchor),
      messageField.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
      sendButton.heightAnchor.constraint(equalToConstant: 35)
    ])
    
  }
  
}


extension ChatTableView {
  private func constraintLayout() {
    headerViewConstraints()
    messageStackConstraints()
    tableViewContraints()
    //    messageFieldConstraints()
    detailButtonConstraints()
    imageViewConstraints()
    statusStackConstraints()
//    updateUI()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    userProfileImageView.layer.cornerRadius = userProfileImageView.frame.width / 2
    sendButton.layer.cornerRadius = 10
  }
}


extension ChatTableView {
  @objc private func loadDetailsPage() {
    guard let reservationId = reservationId, let controller = controller else {
      return
    }
    DatabaseService.shared.readReservation(reservationId: reservationId) { (result) in
      switch result {
      case .failure:
        break
      case .success(let reservation):
        let reservationDVC = ReservationDetailViewController(reservation)
        controller.navigationController?.pushViewController(reservationDVC, animated: true)
      }
    }
    
    
    print("load details button works")
  }
  
  @objc private func sendMessage() {
    print("message button works")
    guard let chatId = chatId,
      let user = Auth.auth().currentUser,
      let text = messageField.text, !text.isEmpty else {
        print("missing message")
        return
    }
    let message = Message(id: UUID().uuidString, content: text, created: Timestamp(date: Date()), senderID: user.uid, senderName: user.displayName ?? "no display name")
    
    DatabaseService.shared.sendChatMessage(message, chatId: chatId) { [weak self] (result) in
      switch result {
      case .failure(let error):
        print("failed \(error)")
      case .success:
        print("check fire base")
        self?.messageField.text = ""
      }
    }
  }
  
  public func updateUI() {
//    guard let user = Auth.auth().currentUser else { return }

//    userProfileImageView.layer.cornerRadius = userProfileImageView.frame.width / 2

    
    guard let reservationID = reservationId else { return }
    DatabaseService.shared.readReservation(reservationId: reservationID) { [weak self] (result) in
      switch result {
      case .failure:
        break
      case .success(let reservation):
        self?.hostId = reservation.hostId
        if reservation.status == 2 {
          self?.statusLabel.text = "PENDING"
          self?.statusLabel.textColor = .systemRed
          self?.statusLabel.backgroundColor = .clear
          self?.rightStatusView.backgroundColor = .clear
          self?.leftStatusView.backgroundColor = .clear

        } else if reservation.status == 1  {
          self?.statusLabel.text = "DECLINED"
          self?.statusLabel.textColor = .black
          self?.statusLabel.backgroundColor = .systemRed
          self?.rightStatusView.backgroundColor = .systemRed
          self?.leftStatusView.backgroundColor = .systemRed

        } else if reservation.status == 0 {
          self?.statusLabel.text = "ACCEPTED"
          self?.statusLabel.textColor = .black
          self?.statusLabel.backgroundColor = .systemGreen
          self?.rightStatusView.backgroundColor = .systemGreen
          self?.leftStatusView.backgroundColor = .systemGreen

        }
      }
    }
    
    guard let hostId = hostId else { return }
    DatabaseService.shared.loadUser(userId: hostId) { [weak self] (result) in
      switch result {
      case .failure(let error):
        print("Error loading user: \(error)")
      case .success(let user):
        print("user loaded \n\(user.profileImage)")
        if let profileString = user.profileImage {
          self?.userProfileImageView.kf.setImage(with: URL(string: profileString))
        } else {
          self?.userProfileImageView.image = UIImage(systemName: "person.fill")
        }
      }
    }
  }
  
}
