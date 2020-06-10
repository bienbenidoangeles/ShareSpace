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
    
    private enum GeoCodeErrors: Error {
        case addressError(String)
    }
    
    public static let shared = CoreLocationSession()
    
    public var locationManager: CLLocationManager
    
    public var geoCoder:CLGeocoder
    
    private override init() {
        locationManager = CLLocationManager()
        geoCoder = CLGeocoder()
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
    
    //use google places to convert
    func convertAddressToCoors(address: String, completion: @escaping (Result<[CLLocationCoordinate2D], Error>) -> ()){
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            if let error = error {
                completion(.failure(error))
            } else if let placemarks = placemarks {
                let coordinates = placemarks.compactMap{$0.location?.coordinate}
                completion(.success(coordinates))
//                else {
//                    let error:GeoCodeErrors = .addressError("\(address) could not be geoCoded properly")
//                    completion(.failure(error))
//                }
                
            }
        }
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
