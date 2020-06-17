//
//  dummy.swift
//  ShareSpace
//
//  Created by Bienbenido Angeles on 5/27/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import Foundation
import Firebase

enum UserType: Int, Codable{
    case guest
    case user
    case host
    case hostAndUser
}

class AppState {
    
    private init() {}
    static let shared = AppState()
    
    var userType:UserType?
    
    func setAppState(userType: UserType){
        self.userType = userType
    }
    
    func getAppState() -> UserType?{
        return userType
    }
}


class UserModel: Codable {
    
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
    let profileImage:String? // this needs to be included under the updateDataBaseUser func arguements
    let governmentId: String?
    let creditCard: String?
    let cardCVV: String?
    let cardExpDate: String?
    
    internal init(userEmail: String, userId: String, firstName: String, lastName: String, displayName: String, bio: String?, phoneNumber: String, work: String?, reviews: [Review]?, userType: UserType, profileImage: String?, governmentId: String?, creditCard: String?, cardCVV: String?, cardExpDate: String?) {
        self.userEmail = userEmail
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.displayName = displayName
        self.bio = bio
        self.phoneNumber = phoneNumber
        self.work = work
        self.reviews = reviews
        self.userType = userType
        self.profileImage = profileImage
        self.governmentId = governmentId
        self.creditCard = creditCard
        self.cardCVV = cardCVV
        self.cardExpDate = cardExpDate
    }
    
    init(_ dictionary: [String: Any]) {
        
        self.userEmail = dictionary["email"] as? String ?? "nil"
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
        self.governmentId = dictionary["governmentId"] as? String ?? "nil"
        self.creditCard = dictionary["creditCard"] as? String ?? "nil"
        self.cardCVV = dictionary["cardCVV"] as? String ?? "nil"
        self.cardExpDate = dictionary["cardExpDate"] as? String ?? "nil"
    }
    
}

class HostModel: UserModel {
    
    let posts: [Post]
    
    init(userEmail: String, userId: String, firstName: String, lastName: String, displayName: String, bio: String?, phoneNumber: String, work: String?, reviews: [Review]?, userType: UserType, profileImage: String?, posts: [Post], governmentId: String?, creditCard: String?, cardCVV: String?, cardExpDate: String?) {
        self.posts = posts
        super.init(userEmail: userEmail, userId: userId, firstName: firstName, lastName: lastName, displayName: displayName, bio: bio, phoneNumber: phoneNumber, work: work, reviews: reviews, userType: userType, profileImage: profileImage, governmentId: governmentId, creditCard: creditCard, cardCVV: cardCVV, cardExpDate: cardExpDate)
    }
    
    override init(_ dictionary: [String : Any]) {
        self.posts = dictionary["post"] as? [Post] ?? [Post]()
        super.init(dictionary)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
