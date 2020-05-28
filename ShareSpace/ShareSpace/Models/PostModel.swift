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
    let price: Double
    let postTitle: String
    let hostName: String
    let listedDate: Date
    let hostId: String
    let mainImage: String
    let images: [String]
    let description: String
    let location: Location    //let amenities: [String]
    let rating: Double
    
    
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
        self.postId = dictionary["postId"] as? String ?? ""
        self.price = dictionary["price"] as? Double ?? 0
        self.postTitle = dictionary["postTitle"] as? String ?? ""
        self.hostName = dictionary["hosyName"] as? String ?? ""
        self.listedDate = dictionary["listedDate"] as? Date ?? Date()
        self.hostId = dictionary["hostId"] as? String ?? ""
        self.mainImage = dictionary["mainImage"] as? String ?? ""
        self.images = dictionary["images"] as? [String] ?? [""]
        self.location = dictionary["location"] as? Location ?? Location(["country": "USA", "streetAddress": "110 Baker Street", "city": "Oxford", "state": "MS", "zip": 38655])
        self.description = dictionary["description"] as? String ?? ""
        self.rating = dictionary["rating"] as? Double ?? -1.0
    }
}
