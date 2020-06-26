//
//  CL2DCoordinate+Extensions.swift
//  ShareSpace
//
//  Created by Bienbenido Angeles on 6/24/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import CoreLocation

extension CLLocationCoordinate2D: Equatable {
    
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool{
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
    
}
