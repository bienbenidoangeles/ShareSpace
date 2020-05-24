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
}
