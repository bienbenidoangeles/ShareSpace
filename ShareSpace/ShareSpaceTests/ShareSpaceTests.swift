//
//  ShareSpaceTests.swift
//  ShareSpaceTests
//
//  Created by Bienbenido Angeles on 5/24/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import XCTest
import Firebase
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
    
    func testCreatePost() {
        let exp = XCTestExpectation(description: "Post created")
//        guard let user = Auth.auth().currentUser else {
//          XCTFail("No current user logged in")
//          return
//        }
        let post = Post.generatePostAsDict()
        
          DatabaseService.shared.postSpace(post: post) { (result) in
            exp.fulfill()
          switch result {
          case .failure(let error):
            XCTFail("Failed to make post \(error)")
          case .success:
            XCTAssert(true)
          }
        }
        wait(for: [exp], timeout: 10.0)
      }

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
