//
//  TransportRepository.swift
//  MeepTest
//
//  Created by Aitor on 01/12/2020.
//

import Foundation
import RxSwift

struct Region {
    let minLat: Double
    let minLong: Double
    let maxLat: Double
    let maxLong: Double
}

struct City {
    let name: String
}

struct TransportRequest {
    let lowerLeftLatLong: (Double, Double)
    let upperRightLatLong: (Double, Double)
    let city: String
}

extension TransportRequest {
    init(region: Region, city: City) {
        self.lowerLeftLatLong = (region.minLat, region.minLong)
        self.upperRightLatLong = (region.maxLat, region.maxLong)
        self.city = city.name
    }
}

protocol TransportRepositoring {
    func fetchTransports(within region: Region, in city: City) -> Single<[Transport]>
}

protocol TransportAPIClient {
    func fetchAll(by request: TransportRequest) -> Single<[TransportDataModelV1]>
}

protocol TransportDataModelToDomainMapping {
    func map(_ dataModel: [TransportDataModelV1]) -> [Transport]
}

final class TransportDataModelToDomainMapper: TransportDataModelToDomainMapping {
    func map(_ dataModel: [TransportDataModelV1]) -> [Transport] {
        dataModel.map({AnyTransport(id: $0.id,
                                    name: $0.name,
                                    positionX: $0.positionX,
                                    positionY: $0.positionY,
                                    companyZoneId: $0.companyZoneId)})
    }
}

final class TransportRepository: TransportRepositoring {
    private let client: TransportAPIClient
    private let mapper: TransportDataModelToDomainMapping
    
    init(client: TransportAPIClient,
         mapper: TransportDataModelToDomainMapping = TransportDataModelToDomainMapper()) {
        self.client = client
        self.mapper = mapper
    }
    
    func fetchTransports(within region: Region, in city: City) -> Single<[Transport]> {
        client
            .fetchAll(by: .init(region: region, city: city))
            .map(mapper.map)
    }
}
