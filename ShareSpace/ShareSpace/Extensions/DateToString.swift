//
//  DateToString.swift
//  ShareSpace
//
//  Created by Bienbenido Angeles on 6/3/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import Foundation

extension Date {
    func toString(givenFormat format: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dateAsString = dateFormatter.string(from: self)
        return dateAsString
    }
}
