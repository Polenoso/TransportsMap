//
//  APIClient.swift
//  MeepTest
//
//  Created by Aitor on 01/12/2020.
//

import Foundation

protocol TransportAPIClient {
    func fetchAll(by request: TransportRequestV1) -> Single<[TransportDataModelV1]>
}
