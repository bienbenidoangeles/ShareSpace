//
//  PostModel.swift
//  ShareSpace
//
//  Created by Liubov Kaper  on 5/27/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import Foundation
import Firebase
import MapKit

struct Post:Codable {
    let postId: String
    let price: Double // post vc
    let postTitle: String // post vc
    let userId: String
    let listedDate: Date
    let mainImage: String?
    let images: [String]? // sub-collection
    let description: String // post vc
    let amenities: [String]
    let country: String?
    let streetAddress: String
    let apartmentNumber: String?
    let city: String
    let state: String
    let zip: String
    //let locationId: String
    var fullAddress: String? {
        get {
            return "\(streetAddress) \(apartmentNumber ?? "") \(city), \(state) \(zip) \(country ?? "")"
        }
    }
    var cityState: String? {
        get{
            return "\(city), \(state)"
        }
    }
    
    let longitude:Double?
    let latitude:Double?
    
    var coordinate: CLLocationCoordinate2D? {
        guard let lat = latitude,
            let long = longitude else {
                return nil
        }
        
        return CLLocationCoordinate2D(
            latitude: lat,
            longitude: long)
    }
    let rating: Double?
    let ratingImgURL: String?
    var postDict: [String:Any] {
        return [
            "postId": postId,
            "price": price,
            "postTitle": postTitle,
            "userId": userId,
            "listedDate": listedDate,
            "mainImage": mainImage,
            "images": images ?? [String](),
            "description": description,
            "amenities": amenities,
            "country": country,
            "streetAddress": streetAddress,
            "apartmentNumber":apartmentNumber ?? "",
            "city": city,
            "state": state,
            "zip": zip,
            "fullAddress": fullAddress ?? "",
            "cityState":cityState ?? "",
            "latitude": latitude ?? 0.0,
            "longitude": longitude ?? 0.0,
            "rating": rating ?? -0.0,
            "ratingImgURL": ratingImgURL ?? ""
        ]
    }
    //let reviews: [Review]? //sub-collection
    
//    enum postType: String {
//        case gym
//        case other
//    }
    
//    static func generatePost()-> Post{
//        
//        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
//        var randomReviewDesc:String = ""
//        for _ in 0...10{
//            randomReviewDesc.append(letters.randomElement()!)
//        }
//        
//        var randomUIDs:String = ""
//        DatabaseService.shared.loadIDs { (result) in
//            switch result {
//            case .failure:
//                break
//            case .success(let uids):
//                randomUIDs = uids.randomElement()!
//            }
//        }
//        
//        let locationId:String = UUID().uuidString
//        let postId: String = UUID().uuidString
//        //return Post(postId: UUID().uuidString, price: Price.generatePrice(), postTitle: randomReviewDesc, userId: randomUIDs, listedDate: Date(), mainImage: "mainImgURL", images: nil, description: randomReviewDesc,  amenities: ["washing machine", "WiFi"], location: Location.generateFullLocationWOLatLong(locationId: locationId, postId: postId), locationId: locationId, rating: Rating.generateRating(), reviews: Review.generateReviews())
//        return Post(postId: postId, price: <#T##Double#>, postTitle: <#T##String#>, userId: <#T##String#>, listedDate: <#T##Date#>, mainImage: <#T##String#>, images: <#T##[String]?#>, description: <#T##String#>, amenities: <#T##[String]#>, country: <#T##String#>, streetAddress: <#T##String#>, apartmentNumber: <#T##String?#>, city: <#T##String#>, state: <#T##String#>, zip: <#T##String#>, longitude: <#T##Double?#>, latitude: <#T##Double?#>, rating: <#T##Double?#>)
//    }
    
    static func generatePostAsDict() -> [String: Any] {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        var randomReviewDesc:String = ""
        for _ in 0...10{
            randomReviewDesc.append(letters.randomElement()!)
        }
        
        let randomUIs:[String] = ["08bULUBwqqNbX6opGlUmUdM2xCH2", "0qtGZ0YxnWgsvX63aq1UBC4fpbC3","8e4XfTNmQAcAUsJs2CeY52XEkRJ3"]
        let locationId:String = UUID().uuidString
        let postId: String = UUID().uuidString
        
        let dict:[String:Any] = [
            "postId": UUID().uuidString,
            "price": Price.generatePriceasDict(),
            "postTitle": randomReviewDesc,
            "userId": randomUIs.randomElement()!,
            "listedDate": Date(), "mainImage": "mainImgURL",
            "images": "nil",
            "description": randomReviewDesc,
            "location": Location.generateFullLocationWLatLongAsDict(locationId: locationId, postId: postId),
            "locationId": locationId,
            "rating": Rating.generateRatingAsDict(),
            "reviews": Review.generateReviewsAsDict(),
        ]
        return dict
    }
    
}


struct Location: Codable {
    let country: String
    let streetAddress: String
    let apartmentNumber: String?
    let city: String
    let state: String
    let zip: String
    let locationId: String
    let postId:String
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
    
    let longitude: Double?
    let latitude:Double?
    
    var coordinate: CLLocationCoordinate2D? {
        guard let lat = latitude,
            let long = longitude else {
                return nil
        }
        
        return CLLocationCoordinate2D(
            latitude: lat,
            longitude: long)
    }
    
    var locationDictionary: [String:Any]{
        return [
            "country":country,
            "streetAddress":streetAddress,
            "apartmentNumber":apartmentNumber ?? "",
            "city":city,
            "state":state,
            "zip":zip,
            "locationId": locationId,
            "postId":postId,
            "fullAddress": fullAddress ?? "",
            "latitude": latitude ?? 0.0,
            "longitude": longitude ?? 0.0,
        ]
    }

    
    static func generateFullLocationWOLatLong(locationId: String, postId: String) -> Location{
        let countries:[String] = ["US, CA, MEX"]
        let randomStreetNum = Int.random(in: 100...9999)
        let randomStreetNames: [String] = ["Park Avenue", "Mason Street", "Carroll Street", "Pineapple Street"]
        let randomApartments:[String] = ["4c, 5c, 2f"]
        let randomCity:[String] = ["Bx, Ny, Bk, Q, SI"]
        let randomState:[String] = ["NY"]
        let randomZip:[String] = ["10001", "10402", "10043"]
        
        
        return Location(country: countries.randomElement()!, streetAddress: "\(randomStreetNum) \(randomStreetNames.randomElement()!)", apartmentNumber: randomApartments.randomElement(), city: randomCity.randomElement()!, state: randomState.first!, zip: randomZip.randomElement()!, locationId: locationId, postId: postId, longitude: nil, latitude: nil)
    }
    
    static func generateLongLatLocation() -> (Double, Double) {
        var randomLong: Double {
            Double.random(in: 40...41)
        }
        var randomLat: Double {
            Double.random(in: 73...75) * -1.0
        }
        
        return (randomLat, randomLong)
    }
    
    static func generateFullLocationWLatLongAsDict(locationId: String, postId:String) -> [String: Any] {
        let countries:[String] = ["US", "CA", "MEX"]
        let randomStreetNum = Int.random(in: 100...9999)
        let randomStreetNames: [String] = ["Park Avenue", "Mason Street", "Carroll Street", "Pineapple Street"]
        let randomApartments:String = String(Int.random(in: 1...16)) + String("ABCDEFGHIJKLMNOPQRSTUVWXYZ".randomElement()!)
        let randomCity:String = ["Bx", "Ny", "Bk", "Q", "SI"].randomElement()!
        let randomState:[String] = ["NY"]
        let randomZip:String = ["10001", "10402", "10043"].randomElement()!
        let dict:[String: Any] = [
            "country": countries.randomElement()!,
            "streetAddress": "\(randomStreetNum) \(randomStreetNames.randomElement()!)",
            "apartmentNumber": randomApartments,
            "city": randomCity,
            "state": "NY",
            "zip": randomZip,
            "longitutde": Location.generateLongLatLocation().0,
            "latitude": Location.generateLongLatLocation().1,
            "locationId": locationId,
            "postId":postId,
        ]
        return dict
    }
    
}
extension Location {
    init(_ dictionary: [String: Any]) {
        self.country = dictionary["country"] as? String ?? ""
        self.streetAddress = dictionary["streetAddress"] as? String ?? ""
        self.apartmentNumber = dictionary["apartmentNumber"] as? String ?? ""
        self.city = dictionary["city"] as? String ?? ""
        self.state = dictionary["city"] as? String ?? ""
        self.zip = dictionary["zip"] as? String ?? ""
        self.longitude = dictionary["longitutude"] as? Double ?? 0.0
        self.latitude = dictionary["latitude"] as? Double ?? 0.0
        self.locationId = dictionary["locationId"] as? String ?? "nil"
        self.postId = dictionary["postId"] as? String ?? "nil"
    }
}
extension Post {
    
    init(_ dictionary: [String: Any]) {
        self.postId = dictionary["postId"] as? String ?? "nil"
        //self.price = dictionary["price"] as? Price ?? Price(["subtotal": -1.0, "spaceCut": -1.0, "tax": -1.0, "taxRate": -1.0, "total": -1.0])
        self.price = dictionary["price"] as? Double ?? -1.0
        self.postTitle = dictionary["postTitle"] as? String ?? "nil"
        self.userId = dictionary["userId"] as? String ?? ""
        self.listedDate = dictionary["listedDate"] as? Date ?? Date()
        self.mainImage = dictionary["mainImage"] as? String ?? "nil"
        self.images = dictionary["images"] as? [String] ?? ["nil"]
        //self.location = dictionary["location"] as? Location ?? Location(["country": "nil", "streetAddress": "nil", "city": "nil", "state": "nil", "zip": -1.0])
        self.description = dictionary["description"] as? String ?? ""
        self.amenities = dictionary["amenities"] as? [String] ?? [""]
        //self.rating = dictionary["rating"] as? Rating ?? Rating(["rating": -1.0, "ratingImage": "nil"])
        //self.reviews = dictionary["reviews"] as? [Review] ?? [Review]()
       // self.locationId = dictionary["locationId"] as? String ?? "nil"
        self.country = dictionary["country"] as? String ?? ""
        self.streetAddress = dictionary["streetAddress"] as? String ?? ""
        self.apartmentNumber = dictionary["apartmentNumber"] as? String ?? ""
        self.city = dictionary["city"] as? String ?? ""
        self.state = dictionary["state"] as? String ?? ""
        self.zip = dictionary["zip"] as? String ?? ""
        //self.fullAddress = dictionary["fullAddress"] as? String ?? ""
        //self.cityState = dictionary["cityState"] as? String ?? ""
        self.latitude = dictionary["latitude"] as? Double ?? 0.0
        self.longitude = dictionary["longitude"] as? Double ?? 0.0
        self.rating = dictionary["rating"] as? Double ?? -1.0
        self.ratingImgURL = dictionary["ratingImgURL"] as? String ?? ""
    }
}

struct Rating:Codable {
    let ratingNum: Double
    let ratingImage: String
    var ratingDict: [String:Any] {
        return [
            "rantingNum": ratingNum,
            "ratingImage": ratingImage,
        ]
    }
    
    static func generateRating() -> Rating{
        let randomRatingImage:[String] = ["afafafa", "afag", "ghehagbhwe"]
        let randomRatingNum: Double = Double(round(Double.random(in: 0...5))/10.0)
        return Rating(ratingNum: randomRatingNum, ratingImage: randomRatingImage.randomElement()!)
    }
    
    static func generateRatingAsDict() -> [String: Any] {
        let randomRatingImage:[String] = ["afafafa", "afag", "ghehagbhwe"]
        let randomRatingNum: Double = Double(round(Double.random(in: 0...5))/10.0)
        let dict: [String: Any] = ["ratingNum": randomRatingNum, "ratingImage": randomRatingImage.randomElement()!]
        return dict
    }
}

extension Rating {
    init(_ dictionary: [String: Any]) {
        self.ratingNum = dictionary["ratingNum"] as? Double ?? -1.0
        self.ratingImage = dictionary["ratingImage"] as? String ?? "nil"
    }
}

struct Price:Codable {
    var subtotal:Double {
        return spaceRate+spaceCut
    }// postVC
    let spaceRate: Double //postVC
    private var shareSpaceRate:Double?
    var spaceCut: Double {
        return spaceRate * 0.05 //self.spaceCut
                //subtotal*self.spaceRate
    }
    let taxRate: Double
    var tax: Double {
        return subtotal*taxRate
    }
    var total:Double {
        return subtotal + spaceCut + tax
    }
    
    var priceDict:[String:Any]{
        return [
            "spaceRate":spaceRate,
            
        ]
    }
    
    mutating func setShareSpaceRate(percentageZeroThroughOne: Double){
        self.shareSpaceRate = percentageZeroThroughOne
    }
    
    
    
    static func generatePrice() -> Price {
        
        let randomAmount = Double(round(Double.random(in: 0.0...999.99))/100.0)
        let randomPercentage = Double(round(Double.random(in: 0.0...1.0))/100.0)
        return Price(spaceRate: randomPercentage, taxRate: randomPercentage)
    }
    
    static func generatePriceasDict() -> [String: Any] {
        let randomAmount = Double(round(Double.random(in: 0.0...999.99))/10.0)
        let randomPercentage = Double(round(Double.random(in: 0.0...1.0))/10.0)
        let dict = ["subtotal": randomAmount, "spaceRate": randomPercentage, "taxRate": randomPercentage]
        return dict
    }
}

extension Price {
    init(_ dictionary: [String: Any]) {
        //self.subtotal = dictionary["subtotal"] as? Double ?? -1.0
        self.spaceRate = dictionary["spaceRate"] as? Double ?? -1.0
        self.taxRate = dictionary["taxRate"] as? Double ?? -1.0
    }
}
struct Review:Codable {
    let reviewDesc: String
    let userId: String
    let reviewDate: Date
    let reviewId: String
    let reviewType: ReviewType.RawValue
    enum ReviewType: String, Codable, CaseIterable {
        case user
        case host
        case post
    }
    
    static func generateReview()-> Review{
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        var randomReviewDesc:String = ""
        var randomId:String = ""
        for _ in 0...10{
            randomReviewDesc.append(letters.randomElement()!)
            randomId.append(letters.randomElement()!)
        }
        
        let randomUIs:[String] = ["08bULUBwqqNbX6opGlUmUdM2xCH2", "0qtGZ0YxnWgsvX63aq1UBC4fpbC3","8e4XfTNmQAcAUsJs2CeY52XEkRJ3"]
        let randomReviewType = ReviewType.allCases.randomElement()!.rawValue
        
        return Review(reviewDesc: randomReviewDesc, userId: randomUIs.randomElement()!, reviewDate: Date(), reviewId: randomId, reviewType: randomReviewType)
    }
    
    static func generateReviewAsDict() -> [String:Any] {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        var randomReviewDesc:String = ""
        var randomId:String = ""
        for _ in 0...10{
            randomReviewDesc.append(letters.randomElement()!)
            randomId.append(letters.randomElement()!)
        }
        
        let randomUIs:String = ["08bULUBwqqNbX6opGlUmUdM2xCH2", "0qtGZ0YxnWgsvX63aq1UBC4fpbC3","8e4XfTNmQAcAUsJs2CeY52XEkRJ3"].randomElement()!
        let randomReviewType = ReviewType.allCases.randomElement()!.rawValue
        
        let dict:[String:Any] = ["reviewDesc": randomReviewDesc, "userId": randomUIs, "reviewDate": Date(), "reviewId": UUID().uuidString, "reviewType": randomReviewType]
        return dict
    }
    
    static func generateReviews() -> [Review] {
        
        var reviews = [Review]()
        for _ in 0...3 {
            reviews.append(generateReview())
        }
        return reviews
    }
    
    static func generateReviewsAsDict() -> [[String:Any]] {
        var dicts = [[String:Any]]()
        for _ in 0...Int.random(in: 1...3) {
            dicts.append(generateReviewAsDict())
        }
        
        return dicts
    }
}

extension Review {
    init(_ dictionary: [String: Any]) {
        self.reviewDesc = dictionary["reviewDesc"] as? String ?? ""
        self.userId = dictionary["userId"] as? String ?? "no user Id"
        self.reviewDate = dictionary["reviewDate"] as? Date ?? Date()
        self.reviewId = dictionary["reviewId"] as? String ?? "nil"
        self.reviewType = dictionary["reviewType"] as? String ?? "nil"
    }
}
