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
    
    private var dbService = DatabaseService.shared
    
    let db = Firestore.firestore()
    
    //I've fetched the profile of user 2 in previous class from which //I'm navigating to chat view. So make sure you have the following //three variables information when you are on this class.
    var user2Name: String? // user2 - person who gets message
    var user2ImgUrl: String?
    var user2UID = "LdWPXgGHHEeRTtqKvwTWCly97AN2"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("user1: \(currentUser.email ?? "no user 1")")
        print("user2: \(user2Name ?? "no user 2")")
        
        view.backgroundColor = .systemBackground
        
        self.title = user2Name ?? "Chat"
        navigationItem.largeTitleDisplayMode = .never
        maintainPositionOnKeyboardFrameChanged = true
        messageInputBar.inputTextView.tintColor = .blue
        messageInputBar.sendButton.setTitleColor(.blue, for: .normal)
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
       
        loadChat()
    }
    
    func loadChat() {
        //Fetch all the chats which has current user in it
        let fetch = db.collection("Chats").whereField("users", arrayContains: currentUser.uid)
        fetch.getDocuments { (snapshot, error) in
          if let error = error {
            print("Error: \(error)")
            return
          } else {
            // count the number of documents returned
            guard let count = snapshot?.documents.count else {
              return
            }
            
            if count == 0 {
              // no chats available -> create a new instance
             // self.createNewChat()
                DatabaseService.shared.createNewChat(user1ID: self.currentUser.uid, user2ID: self.user2UID) { (result) in
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success:
                        print("Chat created")
                    }
                }
             return
              }
           else if count >= 1 {
              // chats have currentUser id in it
              for doc in snapshot!.documents {
                //if
                let chat = Chat(dictionary: doc.data())
                 // let user2ID = self.user2UID {
                // obtain chat with second user
                if ((chat?.users.contains(self.user2UID)) != nil) {
                  self.docReference = doc.reference
                  self.docReference?.collection("thread").order(by: "created", descending: false).addSnapshotListener(includeMetadataChanges: true, listener: { (snapshot, error) in
                    if let error = error {
                      print("Error: \(error)")
                      return
                    } else {
                      self.messages.removeAll()
                      for message in snapshot!.documents {
                        let msg = Message(dictionary: message.data())
                        self.messages.append(msg!)
                        print("Data: \(msg?.content ?? "no message content found")")
                      }
                      self.messagesCollectionView.reloadData()
                      self.messagesCollectionView.scrollToBottom(animated: true)
                    }
                  })
                  return
                }
              }
              self.createNewChat()
            } else {
              print("it didnt work it this printed")
            }
          }
        }
    }
    
    func createNewChat() {
        let users = [self.currentUser.uid, self.user2UID]
        let data: [String: Any] = [
            "users":users
        ]
        db.collection("chats").addDocument(data: data) { (error) in
            if let error = error {
                print("Unable to create chat! \(error)")
                return
            } else {
                self.loadChat()
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
    
    /*
    private func save(_ message: Message) {
        //Preparing the data as per our firestore collection
        let data: [String: Any] = [
            "content": message.content,
            "created": message.created,
            "id": message.id,
            "senderID": message.senderID,
            "senderName": message.senderName
        ]
        //Writing it to the thread using the saved document reference we saved in load chat function
        Firestore.firestore().collection(DatabaseService.chatsCollection).collection("thread").addDocument(data: data, completion: { (error) in
            if let error = error {
                print("Error Sending message: \(error)")
                return
            }
            self.messagesCollectionView.scrollToBottom()
        })
    }
 */
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        //When use press send button this method is called.
        let message = Message(id: UUID().uuidString, content: text, created: Timestamp(), senderID: currentUser.uid, senderName: currentUser.displayName ?? "No name")
        //calling function to insert and save message
        insertNewMessage(message)
    //    save(message)
        //clearing input field
        inputBar.inputTextView.text = ""
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToBottom(animated: true)
    }
}

extension ChatViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return Sender(id: Auth.auth().currentUser!.uid, displayName: Auth.auth().currentUser?.displayName ?? "Name not found")
    }
    
    //This return the MessageType which we have defined to be text in Messages.swift
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        
        return messages[indexPath.section]
    }
    
    //Return the total number of messages
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        
        if messages.count == 0 {
            print("There are no messages")
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
        return isFromCurrentSender(message: message) ? .blue: .lightGray
    }
    
    /*
    //THis function shows the avatar
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        //If it's current user show current user photo.
        if message.sender.senderId == currentUser.uid {
            SDWebImageManager.shared.loadImage(with: currentUser.photoURL, options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                avatarView.image = image
            }
        } else {
            SDWebImageManager.shared.loadImage(with: URL(string: user2ImgUrl!), options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                avatarView.image = image
            }
        }
    }
 */
    
    //Styling the bubble to have a tail
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight: .bottomLeft
        return .bubbleTail(corner, .curved)
    }
}



