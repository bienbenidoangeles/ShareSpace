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
    var chat:Chat?
  
  public lazy var headerView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    return view
  }()
  
  public lazy var detailsButton: UIButton = {
    let button = UIButton()
    //button.setTitle("Details", for: .normal)
    //button.setTitleColor(.orange, for: .normal)
    button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
    button.isUserInteractionEnabled = true
    button.addTarget(self, action: #selector(loadDetailsPage), for: .touchUpInside)
    return button
  }()
  
//  public lazy var userProfileImageView: UIImageView = {
//    let iv = UIImageView()
//   iv.image = UIImage(systemName: "photo.fill")
//    iv.translatesAutoresizingMaskIntoConstraints = false
//    iv.layer.cornerRadius = iv.frame.width / 2
//    return iv
//  }()
  
  public lazy var statusLabel: UILabel = {
    let label = UILabel()
    label.text = " STATUS "
    label.font = .preferredFont(forTextStyle: .headline)
    //label.backgroundColor = .systemGreen
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
    //view.backgroundColor = .systemGreen
    return view
  }()
  
  public lazy var rightStatusView: UIView = {
    let view = UIView()
    //view.backgroundColor = .systemGreen
    return view
  }()
  
  public lazy var messageField: UITextField = {
    let tv = UITextField()
    tv.returnKeyType = .send
    tv.rightView = self.sendButton
    tv.rightViewMode = .always
    tv.placeholder = "  enter message"
    tv.layer.cornerRadius = 20
    tv.backgroundColor = .white
    return tv
  }()
  
  public lazy var messageInput: UITextView = {
    let tv = UITextView()
    tv.backgroundColor = .clear
    tv.font = .preferredFont(forTextStyle: .subheadline)
    return tv
  }()
  
  public lazy var sendButton: UIButton = {
    let button = UIButton()
    //button.backgroundColor = .purple
    button.backgroundColor = .yummyOrange
    button.isUserInteractionEnabled = true
    button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
    button.setImage(UIImage(systemName: "paperplane"), for: .normal)
    button.tintColor = .white
    //button.layer.borderWidth = 1

    return button
  }()
  
  public lazy var messageStack: UIStackView = {
    let sv = UIStackView()
    sv.axis = .horizontal
    sv.spacing = 4
    //    sv.distribution = .fillEqually
    sv.alignment = .fill
    sv.backgroundColor = .green
    return sv
  }()
  
  public lazy var messageBackView: UIView = {
    let view = UIView()
    //view.backgroundColor = .systemRed
    //view.backgroundColor = .systemTeal
    return view
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
      //      tableView.bottomAnchor.constraint(equalTo: messageStack.topAnchor),
      tableView.heightAnchor.constraint(equalTo: layoutMarginsGuide.heightAnchor, multiplier: 0.85)
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
  
//  private func imageViewConstraints() {
//    headerView.addSubview(userProfileImageView)
//    userProfileImageView.translatesAutoresizingMaskIntoConstraints = false
//    NSLayoutConstraint.activate([
//      userProfileImageView.heightAnchor.constraint(equalTo: headerView.heightAnchor, multiplier: 0.65),
//      userProfileImageView.widthAnchor.constraint(equalTo: userProfileImageView.heightAnchor),
//      userProfileImageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
//      userProfileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4)
//    ])
//  }
  
  
  
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
      //      messageStack.heightAnchor.constraint(equalToConstant: 88),
      sendButton.heightAnchor.constraint(equalToConstant: 35),
      sendButton.widthAnchor.constraint(lessThanOrEqualTo: sendButton.heightAnchor)
    ])
  }
  
  private func customMessageStackConstraints() {
    addSubview(messageBackView)
    addSubview(messageField)
    addSubview(messageInput)
//    addSubview(sendButton)
    messageInput.translatesAutoresizingMaskIntoConstraints = false
    messageBackView.translatesAutoresizingMaskIntoConstraints = false
    messageField.translatesAutoresizingMaskIntoConstraints = false
    sendButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      messageBackView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 0),
      messageBackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
      messageBackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
      messageBackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
      
      messageField.topAnchor.constraint(equalTo: messageBackView.topAnchor, constant: 4),
      messageField.leadingAnchor.constraint(equalTo: messageBackView.leadingAnchor, constant: 4),
      messageField.trailingAnchor.constraint(equalTo: messageBackView.trailingAnchor, constant: -4),
      messageField.bottomAnchor.constraint(equalTo: messageBackView.bottomAnchor, constant: -20),
      sendButton.heightAnchor.constraint(equalToConstant: 32),
      sendButton.widthAnchor.constraint(equalToConstant: 32),
      messageInput.topAnchor.constraint(equalTo: messageField.topAnchor),
      messageInput.leadingAnchor.constraint(equalTo: messageField.leadingAnchor),
      messageInput.trailingAnchor.constraint(equalTo: messageField.trailingAnchor, constant: -33),
      messageInput.bottomAnchor.constraint(equalTo: messageField.bottomAnchor)
    ])
    
    
  }
  
  
}


extension ChatTableView {
  private func constraintLayout() {
    headerViewConstraints()
//        messageStackConstraints()
    tableViewContraints()
    detailButtonConstraints()
   // imageViewConstraints()
    statusStackConstraints()
    customMessageStackConstraints()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    //userProfileImageView.layer.cornerRadius = 5
   // userProfileImageView.layer.borderWidth = 6
    sendButton.layer.cornerRadius = (sendButton.frame.height / 2)
    messageInput.layer.cornerRadius = 20
  }
}


extension ChatTableView {
    @objc private func showActionSheet(){
        let sheet = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
        guard let chatUsers = self.chat?.users, let userId = AuthenticationSession.shared.auth.currentUser?.uid else {
            return
        }
        let otherUser = chatUsers.filter{$0 != userId}.first
        guard let otherValidUser = otherUser else {
            return
        }
        let reportButton = UIAlertAction(title: "Report", style: .default) { (action) in
            
            
            
            let alertVC = UIAlertController(title: "Would you like to report this listing?", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Confirm", style: .default) { (action) in
                Report.reportUser(userId: otherValidUser) { (result) in
                    switch result {
                    case .failure(let error):
                        self.controller?.showAlert(title: "Error", message: error.localizedDescription)
                    case .success:
                        self.controller?.showAlert(title: "User reported", message: "Successful")
                    }
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let actions = [okAction, cancelAction]
            actions.forEach{alertVC.addAction($0)}
            
            
            
        }
        
        let detailsButton = UIAlertAction(title: "View Reservation", style: .default) { (action) in
            self.loadDetailsPage()
        }
        
        let blockButton = UIAlertAction(title: "Block", style: .destructive) { (action) in
            DatabaseService.shared.blockDBUser(selfId: userId, blockedId: otherValidUser) { (result) in
                switch result {
                case .failure(let error):
                    break
                case .success(let bool):
                    break
                }
            }
        }
        
        let cancelButton = UIAlertAction(title: "", style: .cancel, handler: nil)
        
        let actions = [reportButton,detailsButton,cancelButton]
        
        actions.forEach{sheet.addAction($0)}
        controller?.present(sheet, animated: true, completion: nil)
    }
    
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
  }
  
  @objc private func sendMessage() {
    guard let chatId = chatId,
      let user = Auth.auth().currentUser,
      let text = messageInput.text, !text.isEmpty else {
        print("missing message")
        return
    }
    let message = Message(id: UUID().uuidString, content: text, created: Timestamp(date: Date()), senderID: user.uid, senderName: user.displayName ?? "no display name", wasRead: false)
    
    DatabaseService.shared.sendChatMessage(message, chatId: chatId) { [weak self] (result) in
      switch result {
      case .failure(let error):
        print("failed \(error)")
      case .success:
        self?.messageInput.text = ""
      }
    }
  }
  /*
    private func listenerSetup() {
       guard let chatId = chat?.id else {
           return
       }
       listener = Firestore.firestore().collection(DatabaseService.chatsCollection).document(chatId).collection(DatabaseService.threadCollection).order(by: "created", descending: false).addSnapshotListener(includeMetadataChanges: true) { (snapshot, error) in
          if let error = error {
            print("error loading messages: \(error)")
          } else if let snapshot = snapshot {
            self.thread.removeAll()
            for message in snapshot.documents {
              let msg = Message(message.data())
              self.thread.append(msg)
             self.chatView.tableView.scrollToNearestSelectedRow(at: .bottom, animated: true)
   //           print("Message data: \(msg)")
            }
          }
        }
      }
   */
  public func updateUI() {
    guard let reservationID = reservationId else { return }
    Firestore.firestore().collection(DatabaseService.reservationCollection).document(reservationID).addSnapshotListener(includeMetadataChanges: true) { (snapshot, error) in
      if let error = error {
        print("error: \(error)")
      } else if let snapshot = snapshot, let data = snapshot.data() {
        let reservation = Reservation(dict: data)
      }
    }
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
//          self?.statusLabel.textColor = .black
            self?.statusLabel.textColor = .systemGreen
          //self?.statusLabel.backgroundColor = .systemGreen
          //self?.rightStatusView.backgroundColor = .systemGreen
          //self?.leftStatusView.backgroundColor = .systemGreen
          
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
//          self?.userProfileImageView.kf.setImage(with: URL(string: profileString))
//        } else {
//          self?.userProfileImageView.image = UIImage(systemName: "person.fill")
//        }
      }
    }
  }
    }
}
