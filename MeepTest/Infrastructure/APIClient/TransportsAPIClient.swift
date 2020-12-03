//
//  TransportsAPIClient.swift
//  MeepTest
//
//  Created by Aitor on 03/12/2020.
//

import Foundation
import RxSwift

final class TransportsAPIClient: TransportAPIClient {
    func fetchAll(_ request: TransportRequestV1) -> Single<[TransportDataModelV1]> {
        Single.just([])
    }
}
