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

    var dictionary: [String: Any] {
        return ["users": users]
    }
}

extension Chat {

    init?(dictionary: [String: Any]) {
        guard let chatUsers = dictionary["users"] as? [String] else { return nil }
        self.init(users: chatUsers)
    }

}
