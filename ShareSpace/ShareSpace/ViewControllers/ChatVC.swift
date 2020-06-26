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
  private var messageViewConstraint: NSLayoutConstraint!
  
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
//      chatView.tableView.
    }
  }
  
  override func loadView() {
    view = chatView
    view.backgroundColor = .systemGroupedBackground

  }

    override func viewDidLoad() {
        super.viewDidLoad()
//      chatView.userProfileImageView.layer.cornerRadius = chatView.userProfileImageView.frame.width / 2
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
    chatView.tableView.register(ChatCell.self, forCellReuseIdentifier: "chatCell")
    chatView.messageInput.delegate = self
    chatView.messageField.delegate = self
  }
  // TODO: Keyboard handling to be completed
  private func registerForKeyboardNotifications() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)

    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
  }

  private func unregisterForKeyboardNotifications() {
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

  }

  @objc private func keyboardWillShow(_ notification: NSNotification) {

    // UIKeyboardFrameBeginUserInfoKey
    // retrieving keyboard height
    guard let keyboardFrame = notification.userInfo?["UIKeyboardFrameBeginUserInfoKey"] as? CGRect else {
      return
    }


    movedKeyboardUp(keyboardFrame.size.height)
  }

  @objc private func keyboardWillHide(_ notification: NSNotification) {
    resetUI()
  }
/*
   @objc func keyboardWillShow(notification: NSNotification) {
       if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
           if self.view.frame.origin.y == 0 {
               self.view.frame.origin.y -= keyboardSize.height
           }
       }
   }

   @objc func keyboardWillHide(notification: NSNotification) {
       if self.view.frame.origin.y != 0 {
           self.view.frame.origin.y = 0
       }
   }
   */
  private func movedKeyboardUp(_ height: CGFloat) {
    if keyboardIsVisible { return }  // prevents it from moving constraints multiple times
    originalYConstraint = NSLayoutConstraint(item: chatView.messageStack, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 0, constant: 0) // save original value

    print("Original Y = \(originalYConstraint.constant)")
    originalYConstraint.constant -= (height * 0.80)

    UIView.animateKeyframes(withDuration: 1, delay: 0.0, options: [], animations: {
      self.view.layoutIfNeeded()
    }, completion: nil)

    UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options:[] , animations: {
      self.view.layoutIfNeeded()
    }, completion: nil)

    keyboardIsVisible = true
  }

  private func resetUI() {
    keyboardIsVisible = false
    print("Original Y = \(originalYConstraint.constant)")

    messageViewConstraint.constant -= originalYConstraint.constant

    UIView.animate(withDuration: 1.0) {
      self.view.layoutIfNeeded()
    }
  }
  
  
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


extension ChatVC: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    textField.placeholder = ""
  }
  

  
  
  
}

extension ChatVC: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    clearPlaceHolder(textfield: self.chatView.messageField)
  }
  
  private func clearPlaceHolder(textfield: UITextField) {
    textfield.placeholder = ""
  }
  
  private func setPlaceHolder(textfield: UITextField) {
    textfield.placeholder = "enter message"
  }
  
}
