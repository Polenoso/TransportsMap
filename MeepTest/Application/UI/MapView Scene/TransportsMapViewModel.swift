//
//  TransportsMapViewModel.swift
//  MeepTest
//
//  Created by Aitor on 02/12/2020.
//

import Foundation
import RxSwift
import CoreLocation

protocol TransportsMapInput: AnyObject {
    var transportPins: [TransportViewState] { get }
    var mapRegion: MapViewRegion { get }
    var isLoading: Bool { get }
    func onLoad()
    func onPinSelected(coordinate: CLLocationCoordinate2D)
    func onRegionChanged(request: MapViewRegionChangesRequest)
}
protocol TransportsMapOutput: AnyObject {
    func stateChanged()
}

struct TransportsMapViewState {
    let loading: Bool
    let cityName: String
    let minLatitude: Double
    let maxLatitude: Double
    let minLongitude: Double
    let maxLongitude: Double
    var transports: [TransportViewState]
}

final class TransportsMapViewModel: TransportsMapInput {
    private weak var output: TransportsMapOutput?
    var sceneDelegate: TransportsMapViewSceneDelegate?
    var timeout: Int = 300
    
    //MARK: - usecases
    private let transportsFetch: TransportsFetcher
    
    //MARK: - DisposeBag
    private let disposeBag = DisposeBag()
    
    //MARK: - View State
    var transportPins: [TransportViewState] { transports.map(TransportViewState.init) }
    var isLoading: Bool = true
    
    var mapRegion: MapViewRegion
    
    //MARK: - Private parameters
    private var city: City
    private var region: Region
    private var transports: [Transport]
    
    private lazy var regionSubject: PublishSubject<Region> = .init()
    
    init(output: TransportsMapOutput?,
         region: Region,
         city: City,
         transportsFetch: TransportsFetcher) {
        self.transports = []
        self.output = output
        self.city = city
        self.region = region
        self.mapRegion = .init(center: .init(latitude: city.centerLat, longitude: city.centerLon))
        self.transportsFetch = transportsFetch
    }
    
    func onLoad() {
        requestTransports(in: region, and: city)
    }
    
    func onPinSelected(coordinate: CLLocationCoordinate2D) {
        guard let transport = transports.first(where: { $0.positionX == coordinate.longitude && $0.positionY == coordinate.latitude }) else { return }
        sceneDelegate?.onTransportSelected(transport)
    }
    
    func onRegionChanged(request: MapViewRegionChangesRequest) {
        if !regionSubject.hasObservers {
            observeRegionChanges()
        }
        let region = Region(minLat: request.minY,
                            minLong: request.minX,
                            maxLat: request.maxY,
                            maxLong: request.maxX)
        regionSubject.onNext(region)
    }
    
    private func requestTransports(in region: Region, and city: City) {
        isLoading = true
        transportsFetch(region: region, city: city)
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { transports in
                self.transports = transports
                self.output?.stateChanged()
                self.isLoading = false
            })
            .disposed(by: disposeBag)
    }
    
    private func observeRegionChanges() {
        regionSubject
            .observeOn(MainScheduler.instance)
            .distinctUntilChanged()
            .debounce(.milliseconds(timeout), scheduler: MainScheduler.asyncInstance)
            .do(onNext: { [weak self] region in
                guard let strongSelf = self else { return }
                self?.isLoading = true
                strongSelf.requestTransports(in: region, and: strongSelf.city)
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
}
