//
//  ChatViewController.swift
//  ShareSpace
//
//  Created by Yuliia Engman on 6/1/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit
import MessageKit
import Firebase
import FirebaseFirestore
import InputBarAccessoryView
import SDWebImage // we may not need that

class ChatViewController: MessagesViewController {
  
  var currentUser: User = Auth.auth().currentUser!
  private var docReference: DocumentReference?
  var messages: [Message] = []
  //  var chats = Chat([String : Any])
  
  private var dbService = DatabaseService.shared
  private var listener: ListenerRegistration?

  
  let db = Firestore.firestore()
  
  //I've fetched the profile of user 2 in previous class from which //I'm navigating to chat view. So make sure you have the following //three variables information when you are on this class.
  var user2Name: String? // user2 - person who gets message
  var user2ImgUrl: String?
  var user2UID: String?
  var chatId: String?
  var user1ID: String?
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    listenerSetup()
//    Firestore.firestore().collection("chats").document(chatId ?? "no chat id").collection(DatabaseService.threadCollection).order(by: "created", descending: false).addSnapshotListener(includeMetadataChanges: true, listener: { (snapshot, error) in
//      if let error = error {
//        print("Error: \(error)")
//        return
//      } else {
//        self.messages.removeAll()
//        for message in snapshot!.documents {
//          let msg = Message( message.data())
//          self.messages.append(msg)
//          print("Data: \(msg.content ?? "no message content found")")
//        }
//        self.messagesCollectionView.reloadData()
//        self.messagesCollectionView.scrollToBottom(animated: true)
//      }
//    })
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("chatId: \(chatId)")
    
    //    print("user1: \(user1ID ?? "no user 1")")
    print("user2: \(user2UID)")
    
    view.backgroundColor = .systemBackground
    
    self.title = user2UID
    navigationItem.largeTitleDisplayMode = .never
    maintainPositionOnKeyboardFrameChanged = true
    messageInputBar.inputTextView.tintColor = .blue
    messageInputBar.sendButton.setTitleColor(.blue, for: .normal)
    messageInputBar.delegate = self
    messagesCollectionView.messagesDataSource = self
    messagesCollectionView.messagesLayoutDelegate = self
    messagesCollectionView.messagesDisplayDelegate = self
    
    loadChat()
    listenerSetup()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(true)
    listener?.remove()
  }
  
  
  
  func loadChat() {
    
    guard let id = chatId,
      let user = Auth.auth().currentUser else {
        print("no chat id")
        return
    }
    
    DatabaseService.shared.loadChat(userId: user.uid, chatId: id) { [weak self] (result) in
      switch result {
      case .failure(let error):
        print("Error loading chat: \(error)")
        self?.newChat()
      case .success(let thread):
        self?.messages = thread
      }
      self?.messagesCollectionView.reloadData()
      self?.messagesCollectionView.scrollToBottom(animated: true)
    }
    
    
  }
  
  private func newChat() {
    if messages.count == 0 {
      DatabaseService.shared.createNewChat(user1ID: user1ID ?? "no id", user2ID: user2UID ?? "no id" ) { (result) in
        switch result {
        case .failure(let error):
          print("failed: \(error.localizedDescription)")
        case .success:
          print("new chat created")
        }
      }
    } else if messages.count >= 1 {
      loadChat()
    }
  }
  
  private func listenerSetup() {
    listener = Firestore.firestore().collection(DatabaseService.chatsCollection).document(chatId ?? "no id").collection(DatabaseService.threadCollection).order(by: "created", descending: false).addSnapshotListener(includeMetadataChanges: true) { (snapshot, error) in
      if let error = error {
        print("no messages to load")
      } else if let snapshot = snapshot {
        self.messages.removeAll()
        for message in snapshot.documents {
          let msg = Message(message.data())
          self.messages.append(msg)
          self.messagesCollectionView.reloadData()
          self.messagesCollectionView.scrollToBottom(animated: true)
          print("Message data: \(msg)")
        }
      }
    }
  }
  
  
  private func insertNewMessage(_ message: Message) {
    //add the message to the messages array and reload it
    messages.append(message)
    messagesCollectionView.reloadData()
    DispatchQueue.main.async {
      self.messagesCollectionView.scrollToBottom(animated: true)
    }
  }
  
  
  private func save(_ message: Message) {
    
    DatabaseService.shared.sendChatMessage(message, chatId: chatId ?? "no id") { (result) in
      switch result {
      case .failure(let error):
        print("Error sending message: \(error)")
      case .success:
        print("Message sent - check firebase")
      }
    }
  }
  
}

extension ChatViewController: InputBarAccessoryViewDelegate {
  
  func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
    //When use press send button this method is called.
    let message = Message(id: UUID().uuidString, content: text, created: Timestamp(), senderID: currentUser.uid, senderName: currentUser.displayName ?? "No name")
    //calling function to insert and save message
    insertNewMessage(message)
    save(message)
    //clearing input field
    inputBar.inputTextView.text = ""
    messagesCollectionView.reloadData()
    messagesCollectionView.scrollToBottom(animated: true)
  }
}

extension ChatViewController: MessagesDataSource {
  func currentSender() -> SenderType {
//    guard let user = Auth.auth().currentUser else {
    return Sender(id: Auth.auth().currentUser!.uid, displayName: Auth.auth().currentUser?.displayName ?? "Name not found")
  }
  
  //This return the MessageType which we have defined to be text in Messages.swift
  
  func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
    
    return messages[indexPath.section]
  }
  
  //Return the total number of messages
  
  func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
    
    if messages.count == 0 {
      print("NumberOfSections -->>  here are no messages")
      return 0
    } else {
      return messages.count
    }
  }
}

extension ChatViewController: MessagesLayoutDelegate {
  //We want the default avatar size. This method handles the size of the avatar of user that'll be displayed with message
  func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
    return .zero
  }
  //Explore this delegate to see more functions that you can implement but for the purpose of this tutorial I've just implemented one function.}
}

extension ChatViewController: MessagesDisplayDelegate {
  //Background colors of the bubbles
  func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
    return isFromCurrentSender(message: message) ? .magenta : .lightGray
  }
  
  
  //THis function shows the avatar
//  func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
//    //If it's current user show current user photo.
//    if message.sender.senderId == currentUser.uid {
//      SDWebImageManager.shared.loadImage(with: currentUser.photoURL, options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
//        avatarView.image = image
//      }
//    } else {
//      SDWebImageManager.shared.loadImage(with: URL(string: user2ImgUrl!), options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
//        avatarView.image = image
//      }
//    }
//  }
  
  
  //Styling the bubble to have a tail
  func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
    let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight: .bottomLeft
    return .bubbleTail(corner, .curved)
  }
}



