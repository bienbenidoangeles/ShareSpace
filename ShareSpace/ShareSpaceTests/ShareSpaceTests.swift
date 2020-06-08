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
  
  func testAuthFuncCreateUser() {
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
          XCTFail("Failed to create database user: \(error)")
        } else {
          exp.fulfill()
          XCTAssert(true)
        }
    }
    wait(for: [exp], timeout: 3.0)
  }
  
  func testDBFuncLoadUser() {
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
   
  func testDBFuncLoadPost() {
    let exp = XCTestExpectation(description: "Post loaded")
    DatabaseService.shared.loadPost { (result) in
      exp.fulfill()
      switch result {
      case .failure(let error):
        XCTFail("Failed to load any post: \(error)")
      case .success(let post):
        if post.count > 0 {
          XCTAssert(true)
        } else {
          XCTFail("No post test to load")
        }
      }
    }
    wait(for: [exp], timeout: 3.0)
  }
  
  func testDBFuncDeleteUser() {
    let exp = XCTestExpectation(description: "User deleted")
    guard let user = Auth.auth().currentUser else {
      XCTFail("No current user")
      return
    }
    
    DatabaseService.shared.deleteDatabaseUser(userId: user.uid) { (result) in
      switch result {
      case .failure(let error):
        XCTFail("Failed to delete user: \(error)")
      case .success:
        exp.fulfill()
        XCTAssert(true)
      }
    }
    wait(for: [exp], timeout: 3.0)
    
  }
  
  func testAuthFuncDeleteUser() {
    let exp = XCTestExpectation(description: "User deleted")
    guard let user = Auth.auth().currentUser else {
      XCTFail("No current user logged in")
      return
    }
    AuthenticationSession.shared.deleteUser(userId: user.uid) { (result) in
      switch result {
      case .failure(let error):
        XCTFail("Issue deleting user: \(error)")
      case .success:
        exp.fulfill()
        XCTAssert(true)
      }
    }
    wait(for: [exp], timeout: 3.0)
  }
  

  func testCreateNewChat() {
    let exp = XCTestExpectation(description: "Chat created")
    guard let user = Auth.auth().currentUser else {
      XCTFail("no current user")
      return
    }
    DatabaseService.shared.createNewChat(user1ID: "ZjorXCGS6cZAnJY47PHG2Sr8y462", user2ID: "j6NB9Ve4cqQWXyheiqYHkotczQY2") { (result) in
      exp.fulfill()
      switch result {
      case .failure(let error):
        XCTFail("Failed to create chat: \(error)")
      case .success:
        XCTAssert(true)
      }
    }
    wait(for: [exp], timeout: 3.0)
  }
  
//  func testChatLoad() {
//    let exp = XCTestExpectation(description: "chats loaded")
//    guard let user = Auth.auth().currentUser else {
//      XCTFail("no current user")
//      return
//    }
//    DatabaseService.shared.loadChatOptions(userId: user.uid) { (result) in
//      exp.fulfill()
//      switch result {
//      case .failure(let error):
//        XCTFail("Failed to load chat: \(error)")
//      case .success(let users):
//        if users.count <= 0 {
//          XCTFail("no chats loaded")
//        } else {
//          XCTAssert(true, "\(users.count) chats loaded")
//        }
//      }
//    }
//    wait(for: [exp], timeout: 3.0)
//  }
  
//  func testLoadSingleChat() {
//    let exp = XCTestExpectation(description: "chats loaded")
//    let id = "iujeuXZDjOjoyeZPvvbC"
//    DatabaseService.shared.loadChat(chatId: id) { (result) in
//      exp.fulfill()
//      switch result {
//      case .failure(let error):
//        XCTFail("failed to pass: \(error)")
//      case .success(let chat):
//        XCTAssertEqual(chat.id, id)
//      }
//    }
//    wait(for: [exp], timeout: 3.0)
//  }
  
  
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
  
//  func randomUser2() -> {
//    let email = "\(randomEmail())@chatUser.com"
//    AuthenticationSession.shared.createNewUser(email: email, password: "password") { (result) in
//      switch result {
//      case .failure(let error):
//        print("failed to make auth user")
//      case .success(let data):
//        DatabaseService.shared.createDatabaseUser(authDataResult: data) { (result) in
//          switch result {
//          case .failure(let error):
//            print("Database error: \(error)")
//          case .success:
//            print("random user 2 created")
//          }
//        }
//      }
//    }
//  }
}
