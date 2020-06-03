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
  static let chatsTestCollection = "chatTest"
  static let favoritesCollection = "favorites"
  static let chatsCollection = "chats"
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
    
    func loadIDs(completion: @escaping (Result<[String], Error>) -> ()) {
    db.collection(DatabaseService.usersCollection).getDocuments { (snapshot, error) in
      if let error = error {
        completion(.failure(error))
      } else if let snapshot = snapshot {
        let users = snapshot.documents.map { UserModel($0.data())}
        var userIDs = [String]()
        for i in users {
          userIDs.append(i.userId)
        }
        completion(.success(userIDs))
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
    
    func updateDatabaseUserType(userType: User){
        
    }
  }
    
    public func createNewChat(user1ID: String, user2ID: String, completion: @escaping (Result<Bool, Error>) -> ()) {
      let users = [user1ID, user2ID]
      let data: [String: Any] = [DatabaseService.usersCollection: users]
          
      db.collection(DatabaseService.chatsCollection).addDocument(data: data) { (error) in
        if let error = error {
          completion(.failure(error))
        } else {
          completion(.success(true))
        }
      }
    }
  
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
  
  func postSpace(hostId: String, price: Price, postTitle: String, hostName: String, mainImage: String, images: [String],description: String, location: Location, rating: Rating, reviews: [Review], completion: @escaping (Result<String, Error>) -> ()) {
    
//    let docRef = db.collection(DatabaseService.postCollection).document()
    /*
     postId: String
     let listedDate: Date
     */
  }
  
  public func createNewChat(user1ID: String, user2ID: String, completion: @escaping (Result<Bool, Error>) -> ()) {
    let users = [user1ID, user2ID]
    let data: [String: Any] = [DatabaseService.usersCollection: users]
        
    db.collection(DatabaseService.chatsCollection).addDocument(data: data) { (error) in
      if let error = error {
        completion(.failure(error))
      } else {
        completion(.success(true))
      }
    }
  }
    
    func postSpace(post: [String:Any], completion: @escaping (Result<Bool, Error>) -> ()) {
    guard let user = Auth.auth().currentUser else { return }
    
    db.collection(DatabaseService.postCollection)
        .document((post["postId"] as? String)!)
        .setData(post) { (error) in
                  
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
}

