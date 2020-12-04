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
    let companyZoneColor: UIColor
    
    init(from transport: Transport) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: transport.positionY, longitude: transport.positionX)
        annotation.title = transport.name
        annotation.subtitle = "\(transport.companyZoneId)"
        self.annotation = annotation
        self.companyZoneColor = CompanyZoneProviders().colorForProvider(id: transport.companyZoneId)
    }
}

struct MapViewRegion {
    let center: CLLocationCoordinate2D
}

struct MapViewRegionChangesRequest {
    let center: CLLocationCoordinate2D
    let maxY: Double
    let minY: Double
    let minX: Double
    let maxX: Double
}
