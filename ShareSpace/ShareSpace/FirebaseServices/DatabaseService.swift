//
//  DatabaseService.swift
//  ShareSpace
//
//  Created by Bienbenido Angeles on 5/24/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class DatabaseService {
    
    static let usersCollection = "users"
    static let postCollection = "post"
    static let threadCollection = "thread"
    static let favoritesCollection = "favorites"
    static let chatsCollection = "chats"
    private var docRef: DocumentReference?
    static let reservationCollection = "reservations"
    static let locationCollection = "locations"
    public let db = Firestore.firestore()
    
    private init() {}
    static let shared = DatabaseService()
    
    public func createDatabaseUser(authDataResult: AuthDataResult, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let email = authDataResult.user.email else {
            return
        }
        db.collection(DatabaseService.usersCollection)
            .document(authDataResult.user.uid)
            .setData(["email" : email,
                      "createdDate": Timestamp(date: Date()),
                      "userId": authDataResult.user.uid,
            ]) { (error) in
                
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(true))
                }
        }
    }
    
    func loadIDs(completion: @escaping (Result<[String], Error>) -> ()) {
        db.collection(DatabaseService.usersCollection).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let users = snapshot.documents.map { UserModel($0.data())}
                var userIDs = [String]()
                for i in users {
                    userIDs.append(i.userId)
                }
                completion(.success(userIDs))
            }
        }
    }
    
    
    //FIXME: change userType from string to UserType
    func updateDatabaseUser(firstName: String, lastName: String, displayName: String, phoneNumber: String, bio: String, work: String , governmentId: String, creditCard: String, cardCVV: String, cardExpDate: String, cityState: String,
        profileImage: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else { return }
        
        db.collection(DatabaseService.usersCollection)
            .document(user.uid)
            .updateData(["firstName": firstName,
                         "lastName": lastName,
                         "displayName": displayName,
                         "phoneNumber": phoneNumber,
                         "bio": bio,
                         "work": work,
                        // "userType": userType,
                         "governmentId": governmentId,
                         "creditCard": creditCard,
                         "cardCVV": cardCVV,
                         "cardExpDate": cardExpDate,
                         "cityState": cityState,
                         "profileImage": profileImage
            ]) { (error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(true))
                }
        }
    }
    
    func createNewChat(user1ID: String, user2ID: String, chatId:String? = nil, completion: @escaping (Result<String, Error>) -> ()) {
        let users = [user1ID, user2ID]
        
        let docRef: DocumentReference = db.collection(DatabaseService.chatsCollection).document()
        //    let docRef: DocumentReference = db.collection(DatabaseService.usersCollection).document(user1ID).collection(DatabaseService.chatsCollection).document()
        
        let chat: [String: Any] = [DatabaseService.usersCollection: users, "chatId": chatId ?? docRef.documentID]
        
        db.collection(DatabaseService.chatsCollection).document(chatId ?? docRef.documentID).setData(chat) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(docRef.documentID))
            }
        }
        
        func updateDatabaseUserType(userType: User){
            
        }
        //          MARK: set to users datbase Chats collection
        //  db.collection(DatabaseService.usersCollection).document(user1ID).collection(DatabaseService.chatsCollection).document(docRef.documentID).setData(chat) { (error) in
        //      if let error = error {
        //        completion(.failure(error))
        //      } else {
        //
        //
        //  self.db.collection(DatabaseService.usersCollection).document(user2ID).collection(DatabaseService.chatsCollection).document(docRef.documentID).setData(chat) { (error) in
        //          if let error = error {
        //            completion(.failure(error))
        //          } else {
        //            completion(.success(true))
        //          }
        //        }
        //      }
        //    }
        
    }
    
    
    
    func loadUserChats(userId: String, completion: @escaping (Result<[Chat], Error>) -> ()) {
        db.collection(DatabaseService.usersCollection).document(userId).collection(DatabaseService.chatsCollection).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let chats = snapshot.documents.map { Chat($0.data())}
                completion(.success(chats))
            }
        }
    }
    
    func loadChatOptions(userId: String, completion: @escaping (Result<[Chat], Error>) -> ()) {
        db.collection(DatabaseService.chatsCollection).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let chats = snapshot.documents.map { Chat($0.data())}
                let userChats = chats.filter { $0.users.contains(userId)}
                completion(.success(userChats))
            }
        }
        
        
        //    db.collection(DatabaseService.chatsCollection).getDocuments { (snapshot, error) in
        //      if let error = error {
        //        completion(.failure(error))
        //      } else if let snapshot = snapshot {
        //        let chats = snapshot.documents.map { Chat($0.data()) }
        //        completion(.success(chats))
        //      }
        //    }
    }
    
    func loadChat(userId: String, chatId: String, completion: @escaping (Result<[Message], Error>) -> ()) {
        var thread = [Message]()
        db.collection(DatabaseService.usersCollection).document(userId).collection(DatabaseService.chatsCollection).document(chatId).collection(DatabaseService.threadCollection).order(by: "created", descending: false).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                
                for message in snapshot.documents {
                    let msg = Message( message.data())
                    thread.append(msg)
                    print("Data: \(msg.content)")
                }
                
                completion(.success(thread))
            }
        }
        //    db.collection(DatabaseService.usersCollection).document(userId).collection(DatabaseService.chatsCollection).document(chatId).collection(DatabaseService.threadCollection).getDocuments { (snapshot, error) in
        //      if let error = error {
        //        completion(.failure(error))
        //      } else if let snapshot = snapshot {
        //        let thread = snapshot.documents.map { Message( $0.data()) }
        //        completion(.success(thread))
        //      }
        //    }
        
        //    db.collection(DatabaseService.chatsCollection).document(chatId).getDocument { (snapshot, error) in
        //      if let error = error {
        //        completion(.failure(error))
        //      } else if let snapshop = snapshot,
        //        let data = snapshop.data() {
        //        let chat = Chat(data)
        //        completion(.success(chat))
        //      }
        //    }
    }
    
    //  func loadChat(userId: String, user2Id: String, completion: @escaping (Result<[Message], Error>) -> ()) {
    //    db.collection(DatabaseService.chatsCollection).whereField(DatabaseService.usersCollection, arrayContains: [userId, user2Id]).getDocuments { (snapshot, error) in
    //      if let error = error {
    //        completion(.failure(error))
    //      } else if let snapshot = snapshot {
    //        if snapshot.documents.count == 0 {
    //          self.createNewChat(user1ID: userId, user2ID: user2Id) { (result) in
    //
    //          }
    //        }
    //      }
    //    }
    //  }
    
    
    //    public func createNewChat(user1ID: String, user2ID: String, completion: @escaping (Result<Bool, Error>) -> ()) {
//          let users = [user1ID, user2ID]
//          let data: [String: Any] = [DatabaseService.usersCollection: users]
//
//          db.collection(DatabaseService.chatsCollection).addDocument(data: data) { (error) in
//            if let error = error {
//              completion(.failure(error))
//            } else {
//              completion(.success(true))
//            }
//          }
    //    }
    
    func loadUser(userId: String, completion: @escaping (Result<UserModel, Error>) -> ()) {
        db.collection(DatabaseService.usersCollection).document(userId).getDocument { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot,
                let data = snapshot.data() {
                let user = UserModel(data)
                completion(.success(user))
            }
        }
    }
    
    func loadPost(postId: String, completion: @escaping (Result<Post, Error>) ->()) {
        db.collection(DatabaseService.postCollection).document(postId).getDocument { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot,
                let data = snapshot.data() {
                let post = Post(data)
                completion(.success(post))
            }
        }
    }
    
    func deleteDatabaseUser(userId: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        db.collection(DatabaseService.usersCollection).document(userId).delete { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    func sendChatMessage(_ message: Message, chatId: String, completion: @escaping (Result<Bool, Error>) -> () ) {
        //    guard let user = Auth.auth().currentUser else { return }
        let message: [String: Any] = message.dictionary
        
        db.collection(DatabaseService.chatsCollection).document(chatId).collection(DatabaseService.threadCollection).addDocument(data: message) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
        
    }
    
    
    
    func postSpace(post: Post, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else { return }
        
        db.collection(DatabaseService.postCollection)
            .document(post.postId)
            .setData(post.postDict) { (error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(true))
                }
        }
    }
    
    func loadReservations(hostId: String, completion: @escaping (Result<[Reservation]?, Error>) ->()) {
        let reservationRef = db.collection(DatabaseService.reservationCollection)
        reservationRef.whereField("hostId", isEqualTo: hostId).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let reservations = snapshot.documents.map{Reservation( dict: $0.data())}
                completion(.success(reservations))
            }
        }
    }
    
    func loadReservedByMe(renterId: String, completion: @escaping (Result<[Reservation]?, Error>) ->()) {
        let reservationRef = db.collection(DatabaseService.reservationCollection)
        reservationRef.whereField("renterId", isEqualTo: renterId).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let reservations = snapshot.documents.map{Reservation( dict: $0.data())}
                completion(.success(reservations))
            }
        }
    }
    
    func loadPosts(userId: String, completion: @escaping (Result<[Post]?, Error>) -> ()){
        let postRef = db.collection(DatabaseService.postCollection)
        postRef.whereField("userId", isEqualTo: userId).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let posts = snapshot.documents.map{Post($0.data())}
                completion(.success(posts))
            }
        }
    }
    
    func loadPosts(coordinateRange: (lat: ClosedRange<Double>, long: ClosedRange<Double>), completion: @escaping (Result<[Post]?, Error>) -> ()) {
        let postRef = db.collection(DatabaseService.postCollection)
        let latUpper = coordinateRange.lat.upperBound
        let latLower = coordinateRange.lat.lowerBound
        let longUpper = coordinateRange.long.upperBound
        let longLower = coordinateRange.long.lowerBound
        postRef.whereField("longitude", isGreaterThanOrEqualTo: longLower).whereField("longitude", isLessThanOrEqualTo: longUpper).limit(to: 256).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                
                
//                snapshot.query.whereField("longitude", isGreaterThanOrEqualTo: longLower).whereField("longitude", isLessThanOrEqualTo: longUpper).limit(to: 16).getDocuments { (snapshot, error) in
//                    if let error = error {
//                        completion(.failure(error))
//                    } else if let snapshot = snapshot  {
//                        let documents = snapshot.documents
//                        if documents.isEmpty {
//                            completion(.success(nil))
//                        } else {
//                            let posts = documents.map{Post($0.data())}
//                            completion(.success(posts))
//                        }
//                    }
//                }
                
                let documents = snapshot.documents

                if documents.isEmpty {
                    completion(.success(nil))
                } else {
                    let mappedPosts =  snapshot.documents.map{Post($0.data())}
                    let filteredPosts = mappedPosts.filter{$0.latitude! >= latLower && $0.latitude! <= latUpper}
                    let selectedPosts = Array(filteredPosts.prefix(16))
//                    let posts = documents.map{Post($0.data())}
                    completion(.success(selectedPosts))
                }
                
            }
        }
        
    }
    
//    func loadPosts(fullStreetAddr: String, geoHash: String, geoHashNeighbors:[String]?, completion: @escaping (Result<[Post], Error>) ->()){
//        let postRef = db.collection(DatabaseService.postCollection)
//        postRef.order(by: "").
//    }
    
    func editPost(postdictionary: [String: Any], completion: @escaping (Result<Bool, Error>) -> ()) {
        let postRef = db.collection(DatabaseService.postCollection)
        guard let postId = postdictionary["postId"] as? String else {
            return
        }
        postRef.document(postId).updateData(postdictionary) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    func createDBLocation(location: [String:Any], completion: @escaping (Result<String, Error>)->()){
        let locationRef = db.collection(DatabaseService.locationCollection)
        let locationId = location["locationId"] as? String ?? UUID().uuidString
        locationRef.document(locationId).setData(location) { (error) in
            if let error = error{
                completion(.failure(error))
            } else {
                completion(.success(locationId))
            }
        }
    }
    
    func readDBLocation(locationId:String, completion: @escaping(Result<Location, Error>) -> ()){
        let locationRef = db.collection(DatabaseService.locationCollection)
        locationRef.document(locationId).getDocument { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            }else if let snapshot = snapshot, let data = snapshot.data() {
                let location = Location(data)
                completion(.success(location))
            }
        }
    }
    
    func readDBLocations(coordinateRange: (lat: ClosedRange<Double>, long: ClosedRange<Double>), completion:  @escaping(Result<[Location]?, Error>) -> () ) {
        let locationRef = db.collection(DatabaseService.locationCollection)
        let latUpper = coordinateRange.lat.upperBound.magnitude
        let latLower = coordinateRange.lat.lowerBound.magnitude
        let longUpper = coordinateRange.long.upperBound
        let longLower = coordinateRange.long.lowerBound
        locationRef.whereField("latitude", isLessThanOrEqualTo: latUpper)
            .whereField("latitude", isGreaterThanOrEqualTo: latLower)
            //.whereField("longitude", isLessThanOrEqualTo: longUpper)
            //.whereField("longitude", isGreaterThanOrEqualTo: longLower)
            .getDocuments { (snapshot, error) in
                if let error = error{
                    completion(.failure(error))
                } else if let snapshot = snapshot {
                    let locations = snapshot.documents.map{Location($0.data())}
                    if locations.isEmpty{
                        completion(.success(nil))
                    } else {
                        completion(.success(locations))
                    }
                }
        }
    }
    
    func createReservation(reservation: [String: Any], completion: @escaping(Result<Bool, Error>) -> ()){
        
        guard let reservationId = reservation["reservationId"] as? String else {
            return
        }
        
        db.collection(DatabaseService.reservationCollection).document(reservationId).setData(reservation) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    func readReservation(reservationId: String, completion: @escaping(Result<Reservation, Error>) -> ()) {
        db.collection(DatabaseService.reservationCollection).document(reservationId).getDocument { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot, let data = snapshot.data() {
                let reservation = Reservation(dict: data)
                completion(.success(reservation))
            }
        }
    }
    
    func updateReservation( reservation: Reservation, completion: @escaping(Result<Bool, Error>) -> ()) {
        let updatedDict:[String:Any] = [
            "checkIn":reservation.checkIn,
            "checkOut": reservation.checkOut,
            "timeIn": reservation.timeIn ?? "",
            "timeOut": reservation.timeOut ?? "",
            "status": reservation.status 
        ]
        
        db.collection(DatabaseService.reservationCollection).document(reservation.reservationId).updateData(updatedDict) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }

  
  func beginChatConversation(user1ID: String, user2ID: String, reservationId: String, message: String, completion: @escaping (Result<Bool, Error>) -> ()) {
    guard let currentUser = Auth.auth().currentUser else { return }
    let id = UUID().uuidString

    let users = [user1ID, user2ID]
    let data: [String: Any] = [DatabaseService.usersCollection: users,
                               "reservationId": reservationId,
                               "chatId": id
    ]
    
    let message = Message(id: UUID().uuidString, content: message, created: Timestamp(date: Date()), senderID: currentUser.uid, senderName: currentUser.displayName ?? "no display name")
    db.collection(DatabaseService.chatsCollection).document(id).collection(DatabaseService.threadCollection).addDocument(data: message.dictionary) { (error) in
      if let error = error {
        completion(.failure(error))
      } else {
        self.db.collection(DatabaseService.chatsCollection).document(id).setData(data)
        completion(.success(true))
      }
    }
    
    
  }
}


