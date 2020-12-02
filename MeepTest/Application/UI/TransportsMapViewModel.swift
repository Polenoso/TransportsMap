//
//  TransportsMapViewModel.swift
//  MeepTest
//
//  Created by Aitor on 02/12/2020.
//

import Foundation
import RxSwift
import MapKit //TODO: remove from VM
import CoreLocation

protocol TransportsMapInput: AnyObject {
    var viewState: TransportsMapViewState { get }
    func onLoad()
}
protocol TransportsMapOutput: AnyObject {
    func stateChanged()
}

struct TransportViewState {
    let annotation: MKAnnotation
    
    init(from transport: Transport) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: transport.positionX, longitude: transport.positionY)
        self.annotation = annotation
    }
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
    private(set) var viewState: TransportsMapViewState
    
    private weak var output: TransportsMapOutput?
    
    //MARK: - usecases
    private let transportsFetch: TransportsFetcher
    
    //MARK: - DisposeBag
    private let disposeBag = DisposeBag()
    
    private var city: City
    private var region: Region
    
    init(output: TransportsMapOutput,
         region: Region,
         city: City,
         transportsFetch: TransportsFetcher) {
        self.viewState = .init(loading: true,
                               cityName: city.name,
                               minLatitude: region.minLat,
                               maxLatitude: region.maxLat,
                               minLongitude: region.minLong,
                               maxLongitude: region.maxLong,
                               transports: [])
        self.output = output
        self.city = city
        self.region = region
        self.transportsFetch = transportsFetch
    }
    
    func onLoad() {
        transportsFetch(region: region, city: city)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { transports in
                self.viewState.transports = transports.map(TransportViewState.init)
                self.output?.stateChanged()
            })
            .disposed(by: disposeBag)

    }
}


