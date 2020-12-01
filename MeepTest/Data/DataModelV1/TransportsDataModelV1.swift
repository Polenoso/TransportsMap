//
//  TransportsDataModelV1.swift
//  MeepTest
//
//  Created by Aitor on 01/12/2020.
//

import Foundation

protocol TransportDataModelV1 {
    var id: String { get }
    var name: String { get }
    var positionX: Double { get }
    var positionY: Double { get }
    var companyZoneId: Int { get }
}

struct AnyTransportDataModelV1: TransportDataModelV1, Decodable {
    let id: String
    let name: String
    let positionX: Double
    let positionY: Double
    let companyZoneId: Int
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case positionX = "x"
        case positionY = "y"
        case companyZoneId
    }
}
