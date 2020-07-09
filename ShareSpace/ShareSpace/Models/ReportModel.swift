//
//  ReportModel.swift
//  ShareSpace
//
//  Created by Bienbenido Angeles on 7/6/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import Foundation
import FirebaseFirestore

public enum ReportableContent {
    case post
    case user
    case reservation
    //case thread
}

struct Report{
    public let reportText: String?
    public var dict: [String:Any] {
        return [
            "reportText": reportText ?? ""
        ]
    }
    
    static func reportUser(userId: String, completion: @escaping (Result<Bool, Error>) ->()){
        DatabaseService.shared.reportUser(userId: userId) { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success:
                completion(.success(true))
            }
        }
    }
    
//    static func reportItem(given id: String, contentType: ReportableContent, report: Report, completion: @escaping (Result<Bool, Error>) -> ()) {
//        switch contentType {
//        case .post:
//            let postDestination = DatabaseService.shared.db.collection(DatabaseService.reportedItemsCollection).document(DatabaseService.reportedPostDocument).collection(id).document(id)
//            DatabaseService.shared.movePost(postId: id, destination: postDestination) { (result) in
//                evalResult(result: result, completion: completion, updateWithReport: report, destination: postDestination, id: id)
//            }
//        case .user:
//            let userDestination = DatabaseService.shared.db.collection(DatabaseService.reportedItemsCollection).document(DatabaseService.reportedDBUserDocument).collection(id).document(id)
//            DatabaseService.shared.movePost(postId: id, destination: userDestination) { (result) in
//                evalResult(result: result, completion: completion, updateWithReport: report, destination: userDestination, id: id)
//            }
//        case .reservation:
//            let reservationDestination = DatabaseService.shared.db.collection(DatabaseService.reportedItemsCollection).document(DatabaseService.reportedReservationsDocument).collection(id).document(id)
//            DatabaseService.shared.movePost(postId: id, destination: reservationDestination) { (result) in
//                evalResult(result: result, completion: completion, updateWithReport: report, destination: reservationDestination, id: id)
//            }
//        }
//    }
//
//    private static func evalResult(result: Result<Bool, Error>, completion: @escaping (Result<Bool, Error>)->(), updateWithReport: Report, destination: DocumentReference, id: String){
//        switch result {
//        case .failure(let error):
//            completion(.failure(error))
//        case .success(let bool):
//            completion(.success(bool))
//            destination.updateData(updateWithReport.dict)
//        }
//    }
}
