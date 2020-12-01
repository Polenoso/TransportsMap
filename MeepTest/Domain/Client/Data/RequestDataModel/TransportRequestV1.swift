//
//  TransportRequestV1.swift
//  MeepTest
//
//  Created by Aitor on 01/12/2020.
//

import Foundation

struct TransportRequestV1 {
    let lowerLeftLatLong: (Double, Double)
    let upperRightLatLong: (Double, Double)
    let city: String
}

extension TransportRequestV1 {
    init(region: Region, city: City) {
        self.lowerLeftLatLong = (region.minLat, region.minLong)
        self.upperRightLatLong = (region.maxLat, region.maxLong)
        self.city = city.name
    }
}
