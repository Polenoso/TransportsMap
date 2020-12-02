//
//  TransportsFetcher.swift
//  MeepTest
//
//  Created by Aitor on 01/12/2020.
//

import Foundation
import RxSwift

enum FetchTransportError: Error {
    case fetchingNotSuccess
}

final class TransportsFetcher {
    private let repository: TransportRepositoring
    
    init(repository: TransportRepositoring) {
        self.repository = repository
    }
    
    func callAsFunction(region: Region, city: City) -> Single<[Transport]> {
        repository
            .fetchTransports(within: region, in: city)
    }
}
