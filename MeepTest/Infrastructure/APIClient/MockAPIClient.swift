//
//  MockAPIClient.swift
//  MeepTest
//
//  Created by Aitor on 02/12/2020.
//

import Foundation
import RxSwift

final class MockAPIClient: TransportAPIClient {
    private let mockData: [TransportDataModelV1] = [AnyTransportDataModelV1(id: "1", name: "name",
                                                                 positionX: 38.71402, positionY: -9.13796,
                                                                 companyZoneId: 223)]
    func fetchAll(_ request: TransportRequestV1) -> Single<[TransportDataModelV1]> {
        Single.just(mockData)
    }
}
