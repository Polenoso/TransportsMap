//
//  Transport.swift
//  MeepTest
//
//  Created by Aitor on 01/12/2020.
//

import Foundation

protocol Transport {
    var id: String { get }
    var name: String { get }
    var positionX: Double { get }
    var positionY: Double { get }
    var companyZoneId: Int { get }
}

struct AnyTransport: Transport {
    let id: String
    let name: String
    let positionX: Double
    let positionY: Double
    let companyZoneId: Int
}
