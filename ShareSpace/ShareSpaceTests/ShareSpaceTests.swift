//
//  ShareSpaceTests.swift
//  ShareSpaceTests
//
//  Created by Bienbenido Angeles on 5/24/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import XCTest
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
@testable import ShareSpace

class ShareSpaceTests: XCTestCase {
  
  func testCreateAuthenticatedUser() {
    let email = "\(randomEmail())@runningtest.com"
    let password = "password"
    let exp = XCTestExpectation(description: "Auth user created")
    
    AuthenticationSession.shared.createNewUser(email: email, password: password) { (result) in
      exp.fulfill()
      switch result {
      case .failure(let error):
        XCTFail("Error creating auth user: \(error.localizedDescription)")
      case .success(let authDataResult):
        XCTAssertEqual(email, authDataResult.user.email)
      }
    }
    wait(for: [exp], timeout: 3.0)
  }
  
  func testCreateDatabaseUser() {
    let exp = XCTestExpectation(description: "Database user created")
    guard let user = FirebaseAuth.Auth.auth().currentUser else {
      XCTFail("no logged user")
      return
    }
    let userDict: [String: Any] = ["email": user.email,
                                   "userId": user.uid,
                                   "createdDate": Date()]
    
    Firestore.firestore().collection(DatabaseService.usersCollection)
      .document(user.uid)
      .setData(userDict) { (error) in
        
        if let error = error {
          XCTFail("Failed to create database user")
        } else {
          exp.fulfill()
          XCTAssert(true)
        }
    }
  }
  
  func testLoadUser() {
    let exp = XCTestExpectation(description: "User profile loaded")
    guard let user = FirebaseAuth.Auth.auth().currentUser else {
      XCTFail("no logged user")
      return
    }
    DatabaseService.shared.loadUser(userId: user.uid) { (result) in
      switch result {
      case .failure(let error):
        XCTFail("failed to load user profile: \(error)")
      case .success(let testUser):
        exp.fulfill()
        XCTAssertEqual(testUser.userId, user.uid)
    }
    }
    wait(for: [exp], timeout: 6.0)
  }
   

  
  
  
  
//  func testSignOut() {
//    let exp =  XCTestExpectation(description: "User logged out")
//    guard let user = Auth.auth().currentUser else {
//      XCTFail("no logged user")
//      return
//    }
//
//    do {
//      try Auth.auth().signOut()
//      exp.fulfill()
//    } catch {
//      XCTFail("failed to log out")
//    }
//    wait(for: [exp], timeout: 4.0)
//  }
  

}



extension ShareSpaceTests {
  func randomEmail() -> String {
    let alphabet = "abcdefghijklmnopqrstuvwxyz"
    var name = ""
    
    for _ in 0..<5 {
      name.append(alphabet.randomElement() ?? "E")
    }
    return name
  }
}
