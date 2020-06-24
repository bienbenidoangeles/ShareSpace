//
//  ReservationModel.swift
//  ShareSpace
//
//  Created by Liubov Kaper  on 6/5/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import Foundation

enum Status: Int, Codable {
    case accepted
    case declined
    case undetermined
}
struct Reservation: Codable {
    let renterId: String
    let hostId: String
    let postId:String
    let checkIn: Date
    let checkOut:Date
    let timeIn: Date?
    let timeOut:Date?
    let chatId: String?
    var status: Status.RawValue
    let reservationId: String
    let totalPrice: Double
    let totalDays: Int
}
extension Reservation {
    init(dict: [String:Any]) {
        self.renterId = dict["renterId"] as? String ?? ""
        self.hostId = dict["hostId"] as? String ?? ""
        self.postId = dict["postId"] as? String ?? ""
        self.checkIn = dict["checkIn"] as? Date ?? Date()
        self.checkOut = dict["checkOut"] as? Date ?? Date()
        self.timeIn = dict["timeIn"] as? Date ?? Date()
        self.timeOut = dict["timeOut"] as? Date ?? Date()
        self.chatId = dict["chatId"] as? String
        self.status = dict["status"] as? Status.RawValue ?? Status.undetermined.rawValue
        self.reservationId = dict["reservationId"] as? String ?? ""
        self.totalPrice = dict["totalPrice"] as? Double ?? 0
        self.totalDays = dict["totalDays"] as? Int ?? 0
    }
}
