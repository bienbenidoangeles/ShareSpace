//
//  DatabaseService.swift
//  ShareSpace
//
//  Created by Bienbenido Angeles on 5/24/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class DatabaseService {
  
  static let usersCollection = "users"
  static let postCollection = "post"
  static let threadCollection = "thread"
  static let favoritesCollection = "favorites"
  static let chatsCollection = "chats"
  private var docRef: DocumentReference?
  private let db = Firestore.firestore()
  
  private init() {}
  static let shared = DatabaseService()
  
  public func createDatabaseUser(authDataResult: AuthDataResult, completion: @escaping (Result<Bool, Error>) -> ()) {
    guard let email = authDataResult.user.email else {
      return
    }
    db.collection(DatabaseService.usersCollection)
      .document(authDataResult.user.uid)
      .setData(["email" : email,
                "createdDate": Timestamp(date: Date()),
                "userId": authDataResult.user.uid,
      ]) { (error) in
        
        if let error = error {
          completion(.failure(error))
        } else {
          completion(.success(true))
        }
    }
  }
  
  func updateDatabaseUser(firstName: String, lastName: String, displayName: String, phoneNumber: String, completion: @escaping (Result<Bool, Error>) -> ()) {
    guard let user = Auth.auth().currentUser else { return }
    
    db.collection(DatabaseService.usersCollection)
      .document(user.uid)
      .updateData(["firstName": firstName,
                   "lastName": lastName,
                   "displayName": displayName,
                   "phoneNumber": phoneNumber,
      ]) { (error) in
        if let error = error {
          completion(.failure(error))
        } else {
          completion(.success(true))
        }
    }
  }
  
  
  func loadPost(completion: @escaping (Result<[Post], Error>) -> ()) {
    db.collection(DatabaseService.postCollection).getDocuments { (snapshot, error) in
      if let error = error {
        completion(.failure(error))
      } else if let snapshot = snapshot {
        let post = snapshot.documents.map { Post($0.data())}
        completion(.success(post.sorted {$0.listedDate > $1.listedDate}))
      }
    }
  }
    
  func createNewChat(user1ID: String, user2ID: String, completion: @escaping (Result<Bool, Error>) -> ()) {
      let users = [user1ID, user2ID]
      
    let docRef: DocumentReference = db.collection(DatabaseService.chatsCollection).document()
//    let docRef: DocumentReference = db.collection(DatabaseService.usersCollection).document(user1ID).collection(DatabaseService.chatsCollection).document()
      
    let chat: [String: Any] = [DatabaseService.usersCollection: users, "chatId": docRef.documentID]
      
    db.collection(DatabaseService.chatsCollection).document(docRef.documentID).setData(chat) { (error) in
      if let error = error {
        completion(.failure(error))
      } else {
        completion(.success(true))
      }
    }
//          MARK: set to users datbase Chats collection
//  db.collection(DatabaseService.usersCollection).document(user1ID).collection(DatabaseService.chatsCollection).document(docRef.documentID).setData(chat) { (error) in
//      if let error = error {
//        completion(.failure(error))
//      } else {
//
//
//  self.db.collection(DatabaseService.usersCollection).document(user2ID).collection(DatabaseService.chatsCollection).document(docRef.documentID).setData(chat) { (error) in
//          if let error = error {
//            completion(.failure(error))
//          } else {
//            completion(.success(true))
//          }
//        }
//      }
//    }
    
  }

  
  
  func loadUserChats(userId: String, completion: @escaping (Result<[Chat], Error>) -> ()) {
    db.collection(DatabaseService.usersCollection).document(userId).collection(DatabaseService.chatsCollection).getDocuments { (snapshot, error) in
      if let error = error {
        completion(.failure(error))
      } else if let snapshot = snapshot {
        let chats = snapshot.documents.map { Chat($0.data())}
        completion(.success(chats))
      }
    }
  }
  
  func loadChatOptions(userId: String, completion: @escaping (Result<[Chat], Error>) -> ()) {
    db.collection(DatabaseService.chatsCollection).getDocuments { (snapshot, error) in
      if let error = error {
        completion(.failure(error))
      } else if let snapshot = snapshot {
        let chats = snapshot.documents.map { Chat($0.data())}
        let userChats = chats.filter { $0.users.contains(userId)}
        completion(.success(userChats))
      }
    }
    
    
//    db.collection(DatabaseService.chatsCollection).getDocuments { (snapshot, error) in
//      if let error = error {
//        completion(.failure(error))
//      } else if let snapshot = snapshot {
//        let chats = snapshot.documents.map { Chat($0.data()) }
//        completion(.success(chats))
//      }
//    }
  }
  
  func loadChat(userId: String, chatId: String, completion: @escaping (Result<[Message], Error>) -> ()) {
    var thread = [Message]()
    db.collection(DatabaseService.usersCollection).document(userId).collection(DatabaseService.chatsCollection).document(chatId).collection(DatabaseService.threadCollection).order(by: "created", descending: false).getDocuments { (snapshot, error) in
         if let error = error {
           completion(.failure(error))
         } else if let snapshot = snapshot {
          
          for message in snapshot.documents {
            let msg = Message( message.data())
            thread.append(msg)
            print("Data: \(msg.content)")
          }
          
           completion(.success(thread))
         }
    }
//    db.collection(DatabaseService.usersCollection).document(userId).collection(DatabaseService.chatsCollection).document(chatId).collection(DatabaseService.threadCollection).getDocuments { (snapshot, error) in
//      if let error = error {
//        completion(.failure(error))
//      } else if let snapshot = snapshot {
//        let thread = snapshot.documents.map { Message( $0.data()) }
//        completion(.success(thread))
//      }
//    }
    
//    db.collection(DatabaseService.chatsCollection).document(chatId).getDocument { (snapshot, error) in
//      if let error = error {
//        completion(.failure(error))
//      } else if let snapshop = snapshot,
//        let data = snapshop.data() {
//        let chat = Chat(data)
//        completion(.success(chat))
//      }
//    }
  }
  
//  func loadChat(userId: String, user2Id: String, completion: @escaping (Result<[Message], Error>) -> ()) {
//    db.collection(DatabaseService.chatsCollection).whereField(DatabaseService.usersCollection, arrayContains: [userId, user2Id]).getDocuments { (snapshot, error) in
//      if let error = error {
//        completion(.failure(error))
//      } else if let snapshot = snapshot {
//        if snapshot.documents.count == 0 {
//          self.createNewChat(user1ID: userId, user2ID: user2Id) { (result) in
//            
//          }
//        }
//      }
//    }
//  }
  
  func loadUser(userId: String, completion: @escaping (Result<UserModel, Error>) -> ()) {
    db.collection(DatabaseService.usersCollection).document(userId).getDocument { (snapshot, error) in
      if let error = error {
        completion(.failure(error))
      } else if let snapshot = snapshot,
        let data = snapshot.data() {
        let user = UserModel(data)
        completion(.success(user))
      }
    }
  }
  
  func deleteDatabaseUser(userId: String, completion: @escaping (Result<Bool, Error>) -> ()) {
    db.collection(DatabaseService.usersCollection).document(userId).delete { (error) in
      if let error = error {
        completion(.failure(error))
      } else {
        completion(.success(true))
      }
    }
  }
  
  func sendChatMessage(_ message: Message, user2ID: String, chatId: String, completion: @escaping (Result<Bool, Error>) -> () ) {
//    guard let user = Auth.auth().currentUser else { return }
    let message: [String: Any] = message.dictionary
    
    db.collection(DatabaseService.chatsCollection).document(chatId).collection(DatabaseService.threadCollection).addDocument(data: message) { (error) in
      if let error = error {
        completion(.failure(error))
      } else {
        completion(.success(true))
        }
      }
    
//    db.collection(DatabaseService.chatsCollection).document(chatId).collection(DatabaseService.threadCollection).addDocument(data: message) { (error) in
//      if let error = error {
//        completion(.failure(error))
//      } else {
//        completion(.success(true))
//      }
//    }
  }
  
  
//}
}
