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
    func onLoad()
    func onPinSelected(coordinate: CLLocationCoordinate2D)
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
    
    //MARK: - usecases
    private let transportsFetch: TransportsFetcher
    
    //MARK: - DisposeBag
    private let disposeBag = DisposeBag()
    
    //MARK: - View State
    var transportPins: [TransportViewState] { transports.map(TransportViewState.init) }
    
    var mapRegion: MapViewRegion
    
    //MARK: - Private parameters
    private var city: City
    private var region: Region
    private var transports: [Transport]
    
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
        transportsFetch(region: region, city: city)
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { transports in
                self.transports = transports
                self.output?.stateChanged()
            })
            .disposed(by: disposeBag)
    }
    
    func onPinSelected(coordinate: CLLocationCoordinate2D) {
        guard let transport = transports.first(where: { $0.positionX == coordinate.longitude && $0.positionY == coordinate.latitude }) else { return }
        sceneDelegate?.onTransportSelected(transport)
    }
}


