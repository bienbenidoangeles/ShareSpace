//
//  CoreLocationSession.swift
//  ShareSpace
//
//  Created by Liubov Kaper  on 6/2/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import Foundation
import MapKit

class CoreLocationSession: NSObject {
    
    private enum GeoCodeErrors: Error {
        case addressError(String)
    }
    
    public static let shared = CoreLocationSession()
    
    public var locationManager: CLLocationManager
    
    public var geoCoder:CLGeocoder
    
    public var searchCompletor: MKLocalSearchCompleter
    
    private override init() {
        locationManager = CLLocationManager()
        geoCoder = CLGeocoder()
        searchCompletor = MKLocalSearchCompleter()
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
    func convertAddressToCoors(address: String, completion: @escaping (Result<[CLLocationCoordinate2D]?, Error>) -> ()){
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
    
    func convertAddressToPlaceMarks(address: String, completion: @escaping (Result<[CLPlacemark]?, Error>) -> ()){
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            if let error = error {
                completion(.failure(error))
            } else if let placemarks = placemarks {
                if placemarks.isEmpty {
                    completion(.success(nil))
                } else {
                    completion(.success(placemarks))
                }
            }
        }
    }
    
    func getMKRegion(given localSearch: MKLocalSearchCompletion, completion: @escaping (Result<MKCoordinateRegion, Error>)-> ()){
        let searchRequest = MKLocalSearch.Request(completion: localSearch)
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            
            if let error = error {
                completion(.failure(error))
            } else if let response = response, let mapItem = response.mapItems.first {
                guard let region = mapItem.placemark.region as? CLCircularRegion else {
                    return
                }
                let mkregion = MKCoordinateRegion(center: region.center, latitudinalMeters: region.radius*2, longitudinalMeters: region.radius*2)
                completion(.success(mkregion))
            }
        }
        
        
    }
    
    func getRegionDetails(region:MKCoordinateRegion) -> (lat: ClosedRange<CLLocationDegrees>, long: ClosedRange<CLLocationDegrees>) {
        let latDelta = region.span.latitudeDelta
        let longDelta = region.span.longitudeDelta
        let radiusTuple = (latRadius: (latDelta/2), longRadius: (longDelta/2))
        let center = region.center
        let latLower = center.latitude - radiusTuple.latRadius
        let latUpper = center.latitude + radiusTuple.latRadius
        let longLower = center.longitude - radiusTuple.longRadius
        let longUpper = center.longitude + radiusTuple.longRadius
        let range = (lat: latLower...latUpper, long: longLower...longUpper)
        return range
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
