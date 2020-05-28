//
//  dummy.swift
//  ShareSpace
//
//  Created by Bienbenido Angeles on 5/27/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import Foundation
import Firebase

struct UserModel {
    let userEmail: String
    let userId: String
    let firstName: String
    let lastName: String
    let displayName: String
    let bio: String?
    let phoneNumber: String
    let work: String?
   // let governmentId: String
   // let payment: String
}

extension UserModel {
    init(_ dictionary: [String: Any]) {
       
        self.userEmail = dictionary["userEmail"] as? String ?? ""
        self.userId = dictionary["userId"] as? String ?? ""
        self.firstName = dictionary["firstName"] as? String ?? ""
        self.lastName = dictionary["lastName"] as? String ?? ""
        self.displayName = dictionary["displayName"] as? String ?? ""
        self.bio = dictionary["bio"] as? String ?? ""
        self.phoneNumber = dictionary["phoneNumber"] as? String ?? ""
        self.work = dictionary["work"] as? String ?? ""
    }
}
