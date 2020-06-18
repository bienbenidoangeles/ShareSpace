//
//  Chat.swift
//  ShareSpace
//
//  Created by Yuliia Engman on 6/1/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//


import UIKit

struct Chat {
  
  var users: [String]
  var id: String
  var reservationId: String
  
  var dictionary: [String: Any] {
    return ["users": users]
  }
}

extension Chat {
  
//  init?(dictionary: [String: Any]) {
//    guard let chatUsers = dictionary["users"] as? [String],
//      let chatId = dictionary["chatId"] as? String else { return nil }
//    self.init(users: chatUsers, id: chatId)
//
//  }
  
  init(_ dictionary: [String: Any]) {
    self.users = dictionary["users"] as? [String] ?? ["nil"]
    self.id = dictionary["chatId"] as? String ?? "no id"
    self.reservationId = dictionary["reservationId"] as? String ?? "nil"
  }
  
}


/*
 {
     
     init(_ dictionary: [String: Any]) {
         self.postId = dictionary["postId"] as? String ?? "nil"
         self.price = dictionary["price"] as? Price ?? Price(["subtotal": -1.0, "spaceCut": -1.0, "tax": -1.0, "taxRate": -1.0, "total": -1.0])
         self.postTitle = dictionary["postTitle"] as? String ?? "nil"
         self.hostId = dictionary["hostId"] as? String ?? "nil"
         self.hostName = dictionary["hosyName"] as? String ?? "nil"
         self.listedDate = dictionary["listedDate"] as? Date ?? Date()
         self.mainImage = dictionary["mainImage"] as? String ?? "nil"
         self.images = dictionary["images"] as? [String] ?? ["nil"]
         self.location = dictionary["location"] as? Location ?? Location(["country": "nil", "streetAddress": "nil", "city": "nil", "state": "nil", "zip": -1.0])
         self.description = dictionary["description"] as? String ?? ""
         self.rating = dictionary["rating"] as? Rating ?? Rating(["rating": -1.0, "ratingImage": "nil"])
         self.reviews = dictionary["reviews"] as? [Review] ?? [Review]()
     }
 }
 */
