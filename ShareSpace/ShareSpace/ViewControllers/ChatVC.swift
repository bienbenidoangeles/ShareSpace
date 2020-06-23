//
//  ChatVC.swift
//  ShareSpace
//
//  Created by Eric Davenport on 6/15/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class ChatVC: UIViewController {
  
  private let chatView = ChatTableView()
  
  private var keyboardIsVisible = false
  
  private var originalYConstraint: NSLayoutConstraint!
  private var messageStachConstraint: NSLayoutConstraint!
  
  private var listener: ListenerRegistration?
  var chat: Chat?
  var user2ID = String() {
    didSet {
      print("user 2: \(user2ID)")
    }
  }

  private var thread = [Message]() {
    didSet {
      chatView.tableView.reloadData()
    }
  }
  
  override func loadView() {
    view = chatView
//    chatView.chatId = chat?.id
//    chatView.reservationId = chat?.reservationId
//    chatView.controller = self
  }

    override func viewDidLoad() {
        super.viewDidLoad()
      listenerSetup()
      tableViewSetup()
//      messageStachConstraint = chatView.messageStack.constraintsAffectingLayout(for: .horizontal)
      chatView.chatId = chat?.id
      chatView.reservationId = chat?.reservationId
      chatView.controller = self
      chatView.hostId = user2ID
      chatView.updateUI()
//      updateUI()
    }
  
  override func viewDidDisappear(_ animated: Bool) {
     super.viewDidDisappear(true)
     listener?.remove()
   }
  
  private func tableViewSetup() {
    chatView.tableView.dataSource = self
    chatView.tableView.delegate = self
    chatView.tableView.register(ChatCell.self, forCellReuseIdentifier: "chatCell")
  }
  // TODO: Keyboard handling to be completed
//  private func registerForKeyboardNotifications() {
//    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//
//    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//  }
//
//  private func unregisterForKeyboardNotifications() {
//    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
//
//  }
//
//  @objc private func keyboardWillShow(_ notification: NSNotification) {
//
//    // UIKeyboardFrameBeginUserInfoKey
//    // retrieving keyboard height
//    guard let keyboardFrame = notification.userInfo?["UIKeyboardFrameBeginUserInfoKey"] as? CGRect else {
//      return
//    }
//
//
//    movedKeyboardUp(keyboardFrame.size.height)
//  }
//
//  @objc private func keyboardWillHide(_ notification: NSNotification) {
//    resetUI()
//  }
//
//  private func movedKeyboardUp(_ height: CGFloat) {
//    if keyboardIsVisible { return }  // prevents it from moving constraints multiple times
//    originalYConstraint = NSLayoutConstraint(item: chatView.messageStack, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 0, constant: 0) // save original value
//
//    print("Original Y = \(originalYConstraint.constant)")
//    originalYConstraint.constant -= (height * 0.80)
//
//    UIView.animateKeyframes(withDuration: 1, delay: 0.0, options: nil, animations: {
//      self.view.layoutIfNeeded()
//    }, completion: nil)
//
////    UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options:[] , animations: {
////      self.view.layoutIfNeeded()
////    }, completion: nil)
//
//    keyboardIsVisible = true
//  }
//
//  private func resetUI() {
//    keyboardIsVisible = false
//    print("Original Y = \(originalYConstraint.constant)")
//
//    pursuitLogoCenterYConstraint.constant -= originalYConstraint.constant
//
//    UIView.animate(withDuration: 1.0) {
//      self.view.layoutIfNeeded()
//    }
//  }
  
  
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
  
//  private func updateUI() {
//    // MARK: Issue: Not loading photo
//    guard let user = Auth.auth().currentUser else { return }
//    DatabaseService.shared.loadUser(userId: user.uid) { [weak self] (result) in
//      switch result {
//      case .failure(let error):
//        print("Error loading user: \(error)")
//      case .success(let user):
//        DispatchQueue.main.async {
//          if let profileString = user.profileImage {
//            self?.chatView.userProfileImageView.kf.setImage(with: URL(string: profileString))
//          } else {
//            self?.chatView.userProfileImageView.image = UIImage(systemName: "person.fill")
//          }
//        }
//
//      }
//    }
//
//  }
    

}


extension ChatVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return thread.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as? ChatCell,
    let user = Auth.auth().currentUser else {
      fatalError("unable to downcast cell")
    }
    let message = thread[indexPath.row]
    cell.message = message
    cell.messageLabel.text = message.content
    if message.senderID == user.uid {
      cell.isIncoming = false
    } else {
      cell.isIncoming = true
      cell.trailingConstraint.isActive = false
      cell.leadingConstraint.isActive = true
      
      cell.incomeDateConstraints.isActive = false
      cell.outgoingDateConstraint.isActive = true
    }
//    cell.message = message
//    cell.backgroundColor = .cyan
//    cell.configureCell(message)
//    cell.setupCell()
    return cell
    
  }
  
  //TODO: seperate messages by date using header
//  func numberOfSections(in tableView: UITableView) -> Int {
//
//  }
//
//  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//
//  }
  
  

}


extension ChatVC: UITableViewDelegate {
//  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//    return 120
//  }
}

extension ChatVC: UITextFieldDelegate {
  
}
