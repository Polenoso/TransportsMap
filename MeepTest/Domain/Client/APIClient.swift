//
//  APIClient.swift
//  MeepTest
//
//  Created by Aitor on 01/12/2020.
//

import Foundation
import RxSwift

protocol TransportAPIClient {
    func fetchAll(_ request: TransportRequestV1) -> Single<[TransportDataModelV1]>
}
