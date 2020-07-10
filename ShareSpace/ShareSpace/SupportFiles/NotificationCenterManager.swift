//
//  NotificationCenterManger.swift
//  ShareSpace
//
//  Created by Bienbenido Angeles on 6/25/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit

class NotificationCenterManager{
    private init(){}
    public static let shared = NotificationCenterManager()
    public static let textFieldDidBeginEditing = Notification.Name(rawValue: "didBeginEditing")
    public static let textFieldDidEndEditing = Notification.Name("textFieldDidEndEditing")
    public static let textFieldShouldReturn = Notification.Name(rawValue: "textFieldShouldReturn")
    public static let textFieldshouldChangeCharactersIn = Notification.Name(rawValue: "textFieldshouldChangeCharactersIn")
    public static let scrollViewDidScroll = Notification.Name(rawValue: "scrollViewDidScroll")
    public static let mapViewDidChangeVisibleRegion = Notification.Name(rawValue: "mapViewDidChangeVisibleRegion")
    public static let userBlockOrUnblocked = Notification.Name("userBlockOrUnblocked")
    
    let nfc = NotificationCenter.default
}
