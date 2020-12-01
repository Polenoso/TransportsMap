//
//  AnyTransportDataModelToDomainSpec.swift
//  MeepTestTests
//
//  Created by Aitor on 01/12/2020.
//

import Foundation
import Quick
import Nimble
@testable import MeepTest

final class AnyTransportDataModelToDomainMapperSpec: QuickSpec {
    override func spec() {
        describe("AnyTransportDataModelToDomainMapper Spec") {
            struct TestDouble {
                static let dataModels: [AnyTransportDataModelV1] = [.init(id: "id1",
                                                                          name: "name1",
                                                                          positionX: 1,
                                                                          positionY: 1,
                                                                          companyZoneId: 1)]
            }
            
            var mapper: AnyTransportDataModelToDomainMapper!
            
            beforeEach {
                mapper = AnyTransportDataModelToDomainMapper()
            }
            
            context("on map") {
                it("should map to AnyTransport") {
                    let expectedResponse = TestDouble.dataModels.first
                    
                    let transports = mapper.map(TestDouble.dataModels)
                    
                    expect(transports.count).to(equal(1))
                    
                    let transport = transports.first
                    
                    expect(transport?.id).to(equal(expectedResponse?.id))
                    expect(transport?.name).to(equal(expectedResponse?.name))
                    expect(transport?.positionX).to(equal(expectedResponse?.positionX))
                    expect(transport?.positionY).to(equal(expectedResponse?.positionY))
                    expect(transport?.companyZoneId).to(equal(expectedResponse?.companyZoneId))
                }
            }
        }
    }
}
