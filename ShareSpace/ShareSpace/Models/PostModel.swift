//
//  PostModel.swift
//  ShareSpace
//
//  Created by Liubov Kaper  on 5/27/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import Foundation
import Firebase

struct Post {
    let postId: String
    let price: Price
    let postTitle: String
    let hostName: String
    let hostId: String
    let listedDate: Date
    let mainImage: String
    let images: [String]
    let description: String
    let location: Location    //let amenities: [String]
    let rating: Rating
    let reviews: [Review]
    
//    enum postType: String {
//        case gym
//        case other
//    }
}

struct Location {
    let country: String
    let streetAddress: String
    let apartmentNumber: String?
    let city: String
    let state: String
    let zip: Int
    var fullAddress: String? {
        get {
            return "\(streetAddress) \(apartmentNumber ?? "") \(city), \(state) \(zip) \(country)"
        }
    }
    var cityState: String? {
        get{
            return "\(city), \(state)"
        }
    }
    
    
}
extension Location {
    init(_ dictionary: [String: Any]) {
        self.country = dictionary["country"] as? String ?? ""
        self.streetAddress = dictionary["streetAddress"] as? String ?? ""
        self.apartmentNumber = dictionary["apartmentNumber"] as? String ?? ""
        self.city = dictionary["city"] as? String ?? ""
        self.state = dictionary["city"] as? String ?? ""
        self.zip = dictionary["zip"] as? Int ?? 0
    }
}
extension Post {
    
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

struct Rating {
    let ratingNum: Double
    let ratingImage: String
}

extension Rating {
    init(_ dictionary: [String: Any]) {
        self.ratingNum = dictionary["ratingNum"] as? Double ?? -1.0
        self.ratingImage = dictionary["ratingImage"] as? String ?? "nil"
    }
}

struct Price {
    let subtotal:Double
    let spaceCut: Double
    let tax: Double
    let taxRate: Double
    let total:Double
}

extension Price {
    init(_ dictionary: [String: Any]) {
        self.spaceCut = dictionary["spaceCut"] as? Double ?? -1.0
        self.subtotal = dictionary["subtotal"] as? Double ?? -1.0
        self.tax = dictionary["tax"] as? Double ?? -1.0
        self.taxRate = dictionary["taxRate"] as? Double ?? -1.0
        self.total = dictionary["total"] as? Double ?? -1.0
    }
}
struct Review {
    let reviewDesc: String
    let user: UserModel
    let reviewDate: Date
    let reviewId: String
    enum reviewType: String {
        case user
        case host
        case post
    }
}

extension Review {
    init(_ dictionary: [String: Any]) {
        self.reviewDesc = dictionary["reviewDesc"] as? String ?? ""
        self.user = dictionary["user"] as? UserModel ?? UserModel(["userEmail":"nil", "userId": "nil", "firstName": "nil", "lastName": "nil", "displayName": "nil", "bio": "nil", "phoneNumber": "nil", "work": "nil", "reviews": [Review](), "userType":"nil", "profileImage": "nil"])
        self.reviewDate = dictionary["reviewDate"] as? Date ?? Date()
        self.reviewId = dictionary["reviewId"] as? String ?? "nil"
    }
}
