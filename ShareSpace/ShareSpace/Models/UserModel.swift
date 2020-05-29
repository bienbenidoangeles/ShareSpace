//
//  dummy.swift
//  ShareSpace
//
//  Created by Bienbenido Angeles on 5/27/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import Foundation
import Firebase

enum UserType: Int{
    case guest
    case user
    case host
}


class UserModel {
    let userEmail: String
    let userId: String
    let firstName: String
    let lastName: String
    let displayName: String
    let bio: String?
    let phoneNumber: String
    let work: String?
    let reviews: [Review]?
    let userType: UserType
    let profileImage:String?
   // let governmentId: String
   // let payment: String
    init(_ dictionary: [String: Any]) {
        
        self.userEmail = dictionary["userEmail"] as? String ?? "nil"
        self.userId = dictionary["userId"] as? String ?? "nil"
        self.firstName = dictionary["firstName"] as? String ?? "nil"
        self.lastName = dictionary["lastName"] as? String ?? "nil"
        self.displayName = dictionary["displayName"] as? String ?? "nil"
        self.bio = dictionary["bio"] as? String ?? "nil"
        self.phoneNumber = dictionary["phoneNumber"] as? String ?? "nil"
        self.work = dictionary["work"] as? String ?? "nil"
        self.reviews = dictionary["reviews"] as? [Review] ?? [Review]()
        self.userType = dictionary["userType"] as? UserType ?? UserType.user
        self.profileImage = dictionary["profileImage"] as? String ?? ""
    }
}

class HostModel: UserModel {
    override init(_ dictionary: [String : Any]) {
        super.init(dictionary)
    }
}
