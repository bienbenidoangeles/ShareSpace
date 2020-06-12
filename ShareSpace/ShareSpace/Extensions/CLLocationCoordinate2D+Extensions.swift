//
//  CLLocationCoordinate2D+Extensions.swift
//  ShareSpace
//
//  Created by Bienbenido Angeles on 6/10/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D {
    var toString:String {
        get {
            return "\(self.latitude),\(self.longitude)"
        }
    }
    
    var roundedToNearestWholeToString: String{
        get {
            return "\(self.latitude.rounded()),\(self.longitude.rounded())"
        }
    }
}
