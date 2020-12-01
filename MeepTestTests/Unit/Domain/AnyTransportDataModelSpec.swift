//
//  AnyTransportDataModelSpec.swift
//  MeepTestTests
//
//  Created by Aitor on 01/12/2020.
//

import Foundation
import Quick
import Nimble
@testable import MeepTest

final class AnyTransportDataModelSpec: QuickSpec {
    override func spec() {
        struct TestDouble {
            static let jsonName = "TransportsSuccessResponse"
        }
        describe("AnyTransportDataModelSpec") {
            var anyTransports: [AnyTransportDataModelV1]?
            
            context("mapping") {
                it("on json read") {
                    let json = JsonLoader.jsonDataNamed("TransportsSuccessResponse")
                    
                    anyTransports = try! JSONDecoder().decode([AnyTransportDataModelV1].self, from: json)
                    let anyTransport = anyTransports?.first
                    
                    expect(anyTransport?.companyZoneId).to(equal(402))
                }
            }
        }
    }
}
