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
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}
