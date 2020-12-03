//
//  TransportsMapViewStateModels.swift
//  MeepTest
//
//  Created by Aitor on 03/12/2020.
//

import Foundation
import MapKit

struct TransportViewState {
    let annotation: MKAnnotation
    
    init(from transport: Transport) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: transport.positionX, longitude: transport.positionY)
        self.annotation = annotation
    }
}

struct MapViewRegion {
    let center: CLLocationCoordinate2D
}
