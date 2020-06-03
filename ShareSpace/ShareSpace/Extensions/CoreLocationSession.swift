//
//  CoreLocationSession.swift
//  ShareSpace
//
//  Created by Liubov Kaper  on 6/2/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import Foundation
import CoreLocation

class CoreLocationSession: NSObject {
    
    public var locationManager: CLLocationManager
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        startSignificantLocationChange()
        
    }
    
    private func startSignificantLocationChange()   {
        if !CLLocationManager.significantLocationChangeMonitoringAvailable()   {
            return
        }
        // less aggressive thant the startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
}

extension CoreLocationSession: CLLocationManagerDelegate    {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations \(locations)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status   {
        case .authorizedAlways:
            print("authorizedAlways")
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
        case .denied:
            print("denies")
        case .notDetermined:
            print("notDetermined")
        case .restricted:
            print("restricted")
        default:
            break
        }
    }
    
}
