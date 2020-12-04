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
                static let regionChangesRequest = MapViewRegionChangesRequest(center: .init(latitude: 1, longitude: 1),
                                                                              maxY: 1, minY: 1, minX: 1, maxX: 2)
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
                spy = nil
                viewModel = nil
            }
            
            context("onLoad") {
                it("should make api call") {
                    spy.fetchAllExpectedResponse = TestDouble.response
                    
                    viewModel.onLoad()
                    
                    expect(spy.fetchAllCalled).toEventually(beTrue())
                    expect(spy.fetchAllCalledTimes).toEventually(equal(1))
                    expect(spy.fetchAllReceivedRequest?.city).toEventually(equal(TestDouble.city.name))
                    expect(spy.fetchAllReceivedRequest?.lowerLeftLatLong.0).toEventually(equal(TestDouble.region.minLat))
                    expect(spy.fetchAllReceivedRequest?.lowerLeftLatLong.1).toEventually(equal(TestDouble.region.minLong))
                    expect(spy.fetchAllReceivedRequest?.upperRightLatLong.0).toEventually(equal(TestDouble.region.maxLat))
                    expect(spy.fetchAllReceivedRequest?.upperRightLatLong.1).toEventually(equal(TestDouble.region.maxLong))
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
                    
                    expect(sceneDelegateSpy.onTransportSelectedCalled).toEventually(beTrue())
                    expect(sceneDelegateSpy.onTransportSelectedRequest?.id).to(equal(TestDouble.mockTransportDataModel.id))
                    expect(sceneDelegateSpy.onTransportSelectedCalledTimes).to(equal(1))
                }
            }
            
            context("on region changed") {
                it("should make api call") {
                    spy.fetchAllExpectedResponse = TestDouble.response
                    viewModel.timeout = 0
                    viewModel.onRegionChanged(request: TestDouble.regionChangesRequest)
                    
                    expect(spy.fetchAllCalled).toEventually(beTrue())
                    expect(spy.fetchAllCalledTimes).toEventually(equal(1))
                    expect(spy.fetchAllReceivedRequest?.city).toEventually(equal(TestDouble.city.name))
                    expect(spy.fetchAllReceivedRequest?.lowerLeftLatLong.0).toEventually(equal(TestDouble.regionChangesRequest.minY))
                    expect(spy.fetchAllReceivedRequest?.lowerLeftLatLong.1).toEventually(equal(TestDouble.regionChangesRequest.minX))
                    expect(spy.fetchAllReceivedRequest?.upperRightLatLong.0).toEventually(equal(TestDouble.regionChangesRequest.maxY))
                    expect(spy.fetchAllReceivedRequest?.upperRightLatLong.1).toEventually(equal(TestDouble.regionChangesRequest.maxX))
                }
                
                it("multiple times same region should make api call just once") {
                    spy.fetchAllExpectedResponse = TestDouble.response
                    viewModel.timeout = 10
                    
                    viewModel.onRegionChanged(request: TestDouble.regionChangesRequest)
                    viewModel.onRegionChanged(request: TestDouble.regionChangesRequest)
                    viewModel.onRegionChanged(request: TestDouble.regionChangesRequest)
                    viewModel.onRegionChanged(request: TestDouble.regionChangesRequest)
                    
                    expect(spy.fetchAllCalled).toEventually(beTrue())
                    expect(spy.fetchAllCalledTimes).toEventually(equal(1))
                    expect(spy.fetchAllReceivedRequest?.city).toEventually(equal(TestDouble.city.name))
                    expect(spy.fetchAllReceivedRequest?.lowerLeftLatLong.0).toEventually(equal(TestDouble.regionChangesRequest.minY))
                    expect(spy.fetchAllReceivedRequest?.lowerLeftLatLong.1).toEventually(equal(TestDouble.regionChangesRequest.minX))
                    expect(spy.fetchAllReceivedRequest?.upperRightLatLong.0).toEventually(equal(TestDouble.regionChangesRequest.maxY))
                    expect(spy.fetchAllReceivedRequest?.upperRightLatLong.1).toEventually(equal(TestDouble.regionChangesRequest.maxX))
                }
                
                it("multiple times different region before debounce should make api call once") {
                    spy.fetchAllExpectedResponse = TestDouble.response
                    viewModel.timeout = 10

                    let differentRegion = MapViewRegionChangesRequest(center: .init(),
                                                                      maxY: 3,
                                                                      minY: 3,
                                                                      minX: 3,
                                                                      maxX: 3)
                    viewModel.onRegionChanged(request: TestDouble.regionChangesRequest)
                    viewModel.onRegionChanged(request: differentRegion)
                    
                    expect(spy.fetchAllCalled).toEventually(beTrue())
                    expect(spy.fetchAllCalledTimes).toEventually(equal(1))
                    expect(spy.fetchAllReceivedRequest?.city).toEventually(equal(TestDouble.city.name))
                    expect(spy.fetchAllReceivedRequest?.lowerLeftLatLong.0).toEventually(equal(differentRegion.minY))
                    expect(spy.fetchAllReceivedRequest?.lowerLeftLatLong.1).toEventually(equal(differentRegion.minX))
                    expect(spy.fetchAllReceivedRequest?.upperRightLatLong.0).toEventually(equal(differentRegion.maxY))
                    expect(spy.fetchAllReceivedRequest?.upperRightLatLong.1).toEventually(equal(differentRegion.maxX))
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
