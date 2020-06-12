//
//  MapView+CenterToLocation.swift
//  ShareSpace
//
//  Created by Bienbenido Angeles on 6/4/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import Foundation
import MapKit

extension MKMapView {
  func centerToLocation(
    _ location: CLLocation
  ) {
    
    
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: getRadius(centralLocation: location),
      longitudinalMeters: getRadius(centralLocation: location))
    setRegion(coordinateRegion, animated: true)
  }
    
    func getRadius(centralLocation: CLLocation) -> Double{
        let topCentralLat:Double = centralLocation.coordinate.latitude -  self.region.span.latitudeDelta/2
        let topCentralLocation = CLLocation(latitude: topCentralLat, longitude: centralLocation.coordinate.longitude)
        let radius = centralLocation.distance(from: topCentralLocation)
        return radius / 100.0 // to convert radius to meters
    }
    
    func getDirections(coordinate: CLLocationCoordinate2D, map: MKMapView) {
        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        request.transportType = .any
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            guard let unwreppedResponse = response else { return}
            for route in unwreppedResponse.routes {
                map.addOverlay(route.polyline)
                map.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
}
