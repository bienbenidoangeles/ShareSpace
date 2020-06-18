//
//  ChatVC.swift
//  ShareSpace
//
//  Created by Eric Davenport on 6/15/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit
import Firebase

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
         print("no messages to load")
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
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as? ChatCell else {
      fatalError("unable to downcast cell")
    }
    let message = thread[indexPath.row]
    cell.message = message
//    cell.backgroundColor = .cyan
    cell.configureCell(message)
    cell.setupCell()
    return cell
    
  }
  
  

}


extension ChatVC: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 120
  }
}

extension ChatVC: UITextFieldDelegate {
  
}
