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

