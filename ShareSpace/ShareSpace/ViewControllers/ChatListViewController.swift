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
  
  
  
  var userIDs = [String]() {
    didSet {
      print("user ids: \(userIDs)")
    }
  }
  
  
  private func loadtest() {
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

  override func loadView() {
    view = chatList
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    loadtest()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableViewSetup()
//    loadChatOptions()
//    loadUserChats()
//    loadtest()
    
    // Do any additional setup after loading the view.
  }
  
  private func tableViewSetup() {
    chatList.tableView.delegate = self
    chatList.tableView.dataSource = self
    chatList.tableView.register(UserCell.self, forCellReuseIdentifier: "userCell")
  }
  
  private func loadUserChats() {
    guard let user = Auth.auth().currentUser else { return }
    DatabaseService.shared.loadUserChats(userId: user.uid) { [weak self] (results) in
      switch results {
      case .failure(let error):
        print("No chats: \(error)")
      case .success(let chats):
        self?.userChats = chats
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
    userIDs = chat.users
    //    print(chat)
        cell.configureCell(chat, userIDs: userIDs)
    //    cell.userNameLabel.text = "\(chat.id)"
    //    cell.backgroundColor = .white
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
      print("no current user")
      return
    }
    for id in users {
      if id != currentUser.uid {
        chatVC.user2ID = id
      }
      //print("user 1 id is \(currentUser.uid)")
      //print("user 2 will be \(users[1])")
    }
    
    chatVC.chat = userChats[indexPath.row]
    
    navigationController?.pushViewController(chatVC, animated: true)
    
  }
}

