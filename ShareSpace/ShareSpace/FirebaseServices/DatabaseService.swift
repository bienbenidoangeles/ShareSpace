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
  
  
  
}
