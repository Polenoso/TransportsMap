//
//  TransportsAPIClientMock.swift
//  MeepTestTests
//
//  Created by Aitor on 01/12/2020.
//

import Foundation
import RxSwift
@testable import MeepTest

final class TransportAPIClientMock: TransportAPIClient {
    func fetchAll(_ request: TransportRequestV1) -> Single<[TransportDataModelV1]> {
        .just([])
    }
}
