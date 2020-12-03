//
//  TransportsAPIClient.swift
//  MeepTest
//
//  Created by Aitor on 03/12/2020.
//

import Foundation
import RxSwift
import Moya
import RxMoya

final class TransportsAPIClient: TransportAPIClient {
    let requestProvider: MoyaProvider<TransportsEndpointCollection> = MoyaProvider()
    func fetchAll(_ request: TransportRequestV1) -> Single<[TransportDataModelV1]> {
        requestProvider.rx.request(.all(request: request))
            .map { (response) -> [TransportDataModelV1] in
                return try JSONDecoder().decode([AnyTransportDataModelV1].self, from: response.data)
            }
    }
}
