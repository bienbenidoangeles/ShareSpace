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
    chatView.chatId = chat?.id
    chatView.reservationId = chat?.reservationId
    chatView.controller = self
  }

    override func viewDidLoad() {
        super.viewDidLoad()
      listenerSetup()
      tableViewSetup()
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
  
  private func updateUI() {
    // MARK: Issue: Not loading photo
    guard let user = Auth.auth().currentUser else { return }
    DatabaseService.shared.loadUser(userId: user.uid) { [weak self] (result) in
      switch result {
      case .failure(let error):
        print("Error loading user: \(error)")
      case .success(let user):
        DispatchQueue.main.async {
          if let profileString = user.profileImage {
            self?.chatView.userProfileImageView.kf.setImage(with: URL(string: profileString))
          } else {
            self?.chatView.userProfileImageView.image = UIImage(systemName: "person.fill")
          }
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
    cell.messageLabel.text = message.content
    if message.senderID == user.uid {
      cell.isIncoming = false
    } else {
      cell.isIncoming = true
      cell.trailingConstraint.isActive = false
      cell.leadingConstraint.isActive = true
    }
//    cell.message = message
//    cell.backgroundColor = .cyan
//    cell.configureCell(message)
//    cell.setupCell()
    return cell
    
  }
  
  

}


extension ChatVC: UITableViewDelegate {
//  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//    return 120
//  }
}

extension ChatVC: UITextFieldDelegate {
  
}
