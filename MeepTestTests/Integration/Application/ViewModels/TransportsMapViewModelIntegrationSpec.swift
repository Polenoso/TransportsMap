//
//  TransportsMapViewModelIntegrationSpec.swift
//  MeepTestTests
//
//  Created by Aitor on 04/12/2020.
//

import Foundation
import Quick
import Nimble
import RxSwift
import CoreLocation
@testable import MeepTest

final class TransportsMapViewModelIntegrationSpec: QuickSpec {
    override func spec() {
        describe("TransportsMapViewModel Integration Spec") {
            struct TestDouble {
                static let region = Region(minLat: 1, minLong: 1, maxLat: 1, maxLong: 1)
                static let city = City(name: "City", centerLat: 1, centerLon: 1)
                static let mockTransportDataModel = AnyTransportDataModelV1(id: "id",
                                                                            name: "name",
                                                                            positionX: mockCoordinate.longitude,
                                                                            positionY: mockCoordinate.latitude,
                                                                            companyZoneId: 1)
                static let response = Single.just([mockTransportDataModel] as [TransportDataModelV1])
                static let mockCoordinate: CLLocationCoordinate2D = .init(latitude: 1, longitude: 1)
            }
            var spy: TransportsAPIClientSpy!
            var viewModel: TransportsMapViewModel!
            
            beforeEach {
                spy = TransportsAPIClientSpy()
                let repository = TransportRepository(client: spy, mapper: AnyTransportDataModelToDomainMapper())
                let fetcher = TransportsFetcher(repository: repository)
                viewModel = TransportsMapViewModel(output: nil,
                                                   region: TestDouble.region,
                                                   city: TestDouble.city,
                                                   transportsFetch: fetcher)
            }
            
            afterEach {
                viewModel = nil
            }
            
            context("onLoad") {
                it("should make api call") {
                    spy.fetchAllExpectedResponse = TestDouble.response
                    
                    viewModel.onLoad()
                    
                    expect(spy.fetchAllCalled).to(beTrue())
                    expect(spy.fetchAllCalledTimes).to(equal(1))
                    expect(spy.fetchAllReceivedRequest?.city).to(equal(TestDouble.city.name))
                    expect(spy.fetchAllReceivedRequest?.lowerLeftLatLong.0).to(equal(TestDouble.region.minLat))
                    expect(spy.fetchAllReceivedRequest?.lowerLeftLatLong.1).to(equal(TestDouble.region.minLong))
                    expect(spy.fetchAllReceivedRequest?.upperRightLatLong.0).to(equal(TestDouble.region.maxLat))
                    expect(spy.fetchAllReceivedRequest?.upperRightLatLong.1).to(equal(TestDouble.region.maxLong))
                }
                
                it("should map result to expected transports view state") {
                    spy.fetchAllExpectedResponse = TestDouble.response
                    
                    viewModel.onLoad()
                    var firstTransport: TransportViewState? { viewModel.transportPins.first }
                    
                    expect(firstTransport?.annotation.coordinate.latitude).toEventually(equal(TestDouble.mockTransportDataModel.positionY))
                    expect(firstTransport?.annotation.coordinate.longitude).toEventually(equal(TestDouble.mockTransportDataModel.positionX))
                }
            }
            
            context("on pin selected") {
                it("should call scene delegate") {
                    spy.fetchAllExpectedResponse = TestDouble.response
                    viewModel.onLoad()
                    let sceneDelegateSpy = TransportsMapSceneDelegateSpy()
                    viewModel.sceneDelegate = sceneDelegateSpy
                    
                    viewModel.onPinSelected(coordinate: TestDouble.mockCoordinate)
                    
                    expect(sceneDelegateSpy.onTransportSelectedCalled).to(beTrue())
                    expect(sceneDelegateSpy.onTransportSelectedRequest?.id).to(equal(TestDouble.mockTransportDataModel.id))
                    expect(sceneDelegateSpy.onTransportSelectedCalledTimes).to(equal(1))
                }
            }
        }
    }
}

class TransportsAPIClientSpy: TransportAPIClient {
    var fetchAllReceivedRequest: TransportRequestV1?
    var fetchAllCalled: Bool = false
    var fetchAllCalledTimes: Int = 0
    var fetchAllExpectedResponse: Single<[TransportDataModelV1]> = .just([])
    
    func fetchAll(_ request: TransportRequestV1) -> Single<[TransportDataModelV1]> {
        fetchAllReceivedRequest = request
        fetchAllCalledTimes += 1
        fetchAllCalled = true
        return fetchAllExpectedResponse
    }
}

class TransportsMapSceneDelegateSpy: TransportsMapViewSceneDelegate {
    var onTransportSelectedRequest: Transport?
    var onTransportSelectedCalled: Bool = false
    var onTransportSelectedCalledTimes: Int = 0
    
    func onTransportSelected(_ transport: Transport) {
        onTransportSelectedRequest = transport
        onTransportSelectedCalled = true
        onTransportSelectedCalledTimes += 1
    }
}
