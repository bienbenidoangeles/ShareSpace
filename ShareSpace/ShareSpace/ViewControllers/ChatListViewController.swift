//
//  ChatListViewController.swift
//  ShareSpace
//
//  Created by Eric Davenport on 6/3/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit
import Firebase

class ChatListViewController: UIViewController {
  
  private var chatList = ChatListView()
  
  var userChats = [Chat]() {
    didSet {
      DispatchQueue.main.async {
        self.chatList.tableView.reloadData()
        print("Chats List \n\n\(self.userChats)")
      }
    }
  }
  
  private var listener: ListenerRegistration?
  
  var userIDs = [String]() {
    didSet {
      print("user ids: \(userIDs)")
    }
  }
  
  var threads = [[Thread]]() {
    didSet {
      print("thread updated")
    }
  }

  override func loadView() {
    view = chatList
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    loadUserChats()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableViewSetup()
    navigationItem.title = "Inbox"
  }
  
  private func tableViewSetup() {
    chatList.tableView.delegate = self
    chatList.tableView.dataSource = self
    chatList.tableView.register(UserCell.self, forCellReuseIdentifier: "userCell")
  }
  
  private func loadUserChats() {
    guard let currentUser = Auth.auth().currentUser else { return }
    DatabaseService.shared.loadChatOptions(userId: currentUser.uid) { (result) in
      switch result {
      case .failure(let error):
        print("error \(error)")
      case .success(let chat):
        self.userChats = chat
      }
    }
    
    
  }

  
}

extension ChatListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return userChats.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? UserCell else {
      fatalError("failed to deque userCell")
    }
    
    
    let chat = userChats[indexPath.row]
    
    listener = Firestore.firestore().collection(DatabaseService.chatsCollection).document(chat.id).collection(DatabaseService.threadCollection).order(by: "created", descending: false).addSnapshotListener(includeMetadataChanges: true) { (snapshot, error) in
      if let error = error {
        print("no messages to load \(error) ")
      } else if let snapshot = snapshot {
        for message in snapshot.documents {
          let msg = Message(message.data())
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "MMM dd HH:mm a"
          let dateString = dateFormatter.string(from: msg.created.dateValue())
          cell.textSnapshot.text = msg.content
          cell.dateLabel.text = "\(dateString)"
        }
      }
    }
    
    
    userIDs = chat.users
    cell.configureCell(chat, ids: userIDs)
    return cell
  }
}


extension ChatListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let chatVC = ChatVC(nibName: nil, bundle: nil)
    
    let users = userChats[indexPath.row].users
    guard let currentUser = Auth.auth().currentUser else {
      return
    }
    for id in users {
      if id != currentUser.uid {
        chatVC.user2ID = id
      }

    }
    
    chatVC.chat = userChats[indexPath.row]
    
    navigationController?.pushViewController(chatVC, animated: true)
    
  }
}

