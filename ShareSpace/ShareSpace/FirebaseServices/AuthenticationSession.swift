//
//  AuthenticationSession.swift
//  ShareSpace
//
//  Created by Bienbenido Angeles on 5/24/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import Foundation
import FirebaseAuth

class AuthenticationSession {
  
  private init() {}
  static let shared = AuthenticationSession()
    
    let auth = Auth.auth()
  
  public func createNewUser(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> ()) {
    auth.createUser(withEmail: email, password: password) { (authDataResult, error) in
      if let error = error {
        completion(.failure(error))
      } else if let authDataResult = authDataResult {
        completion(.success(authDataResult))
      }
    }
  }
  
  public func signExistingUser(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> ()) {
    auth.signIn(withEmail: email, password: password) { (authDataResult, error) in
      if let error = error {
        completion(.failure(error))
      } else if let authDataResult = authDataResult {
        completion(.success(authDataResult))
      }
    }
  }
  
  public func deleteUser(userId: String, completion: @escaping (Result<Bool, Error>) -> ()) {
    auth.currentUser?.delete(completion: { (error) in
      if let error = error {
        completion(.failure(error))
      } else {
        completion(.success(true))
      }
    })
  }
    public func logout() throws{
        do {
            try auth.signOut()
        } catch {
            throw error
        }
        
    }
}
