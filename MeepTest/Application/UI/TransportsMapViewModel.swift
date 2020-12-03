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
    var transports: [TransportViewState] { get }
    var mapRegion: MapViewRegion { get }
    func onLoad()
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
    
    //MARK: - usecases
    private let transportsFetch: TransportsFetcher
    
    //MARK: - DisposeBag
    private let disposeBag = DisposeBag()
    
    //MARK: - View State
    private(set) var transports: [TransportViewState]
    
    var mapRegion: MapViewRegion
    
    //MARK: - Private parameters
    private var city: City
    private var region: Region
    
    init(output: TransportsMapOutput,
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
                self.transports = transports.map(TransportViewState.init)
                self.output?.stateChanged()
            })
            .disposed(by: disposeBag)
    }
}


