//
//  TransportsFetcherSpec.swift
//  MeepTestTests
//
//  Created by Aitor on 02/12/2020.
//

import Foundation
import Quick
import Nimble
import RxSwift
import RxBlocking
@testable import MeepTest

final class TransportsFetcherSpec: QuickSpec {
    override func spec() {
        describe("TransportsFetcher Spec") {
            struct TestDouble {
                static let successRepository = SuccessTransportsRepositoryMock()
                static let errorRepository = ErrorTransportsRepositoryMock()
                static let region = Region(minLat: 1, minLong: 1, maxLat: 1, maxLong: 1)
                static let city = City(name: "City", centerLat: 1, centerLon: 1)
            }
            
            context("on success") {
                it("should return an array of Transport") {
                    let usecase = TransportsFetcher(repository: TestDouble.successRepository)
                    
                    let result = try? usecase(region: TestDouble.region, city: TestDouble.city).toBlocking().first()
                    let first = result?.first
                    
                    expect(result).toNot(beNil())
                    expect(result?.count).to(equal(1))
                    expect(first?.id).to(equal("id"))
                    expect(first?.name).to(equal("name"))
                    expect(first?.positionX).to(equal(1))
                    expect(first?.positionY).to(equal(1))
                    expect(first?.companyZoneId).to(equal(1))
                }
            }
        }
    }
}

final class SuccessTransportsRepositoryMock: TransportRepositoring {
    func fetchTransports(within region: Region, in city: City) -> Single<[Transport]> {
        Single.just([AnyTransport(id: "id",
                                  name: "name",
                                  positionX: 1,
                                  positionY: 1,
                                  companyZoneId: 1)])
    }
}

final class ErrorTransportsRepositoryMock: TransportRepositoring {
    enum MockError: Error {
        case undefined
    }
    func fetchTransports(within region: Region, in city: City) -> Single<[Transport]> {
        Single.error(MockError.undefined)
    }
}
