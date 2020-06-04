//
//  IntTimeIntervalAsSecondsToOther.swift
//  ShareSpace
//
//  Created by Bienbenido Angeles on 6/3/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import Foundation

extension Double {
    static func minutesToSeconds(minutes: Int) -> Double{
        let seconds = minutes*60
        return Double(seconds)
    }
    
    static func hoursToSeconds(hours: Double) -> Double{
        let minutes = hours * 60
        let seconds = minutes * 60
        return seconds
    }
    
    static func hoursAndMinutesToSeconds(minutes: Int, hours: Double) -> Double{
        let secondsAsMinutes = self.minutesToSeconds(minutes: minutes)
        let secondsAsHours = self.hoursToSeconds(hours: hours)
        return secondsAsHours + secondsAsMinutes
    }
}
