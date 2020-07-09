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
    
//    var lastUpdatedDate: Date {
//        return Date() // FIXME: get date and return here
//    }
}

extension Chat {
  
  init(_ dictionary: [String: Any]) {
    self.users = dictionary["users"] as? [String] ?? ["nil"]
    self.id = dictionary["chatId"] as? String ?? "no id"
    self.reservationId = dictionary["reservationId"] as? String ?? "nil"
  }
  
}


