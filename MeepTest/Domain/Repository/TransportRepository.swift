//
//  TransportRepository.swift
//  MeepTest
//
//  Created by Aitor on 01/12/2020.
//

import Foundation
import RxSwift

protocol TransportRepositoring {
    func fetchTransports(within region: Region, in city: City) -> Single<[Transport]>
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
