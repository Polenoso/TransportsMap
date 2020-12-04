//
//  TransportsMapViewCoordinator.swift
//  MeepTest
//
//  Created by Aitor on 04/12/2020.
//

import UIKit

protocol Coordinator: AnyObject {
    func start()
}

final class TransportsMapViewCoordinator {
    private var window: UIWindow?
    private var city: City
    private var region: Region
    
    init(window: UIWindow?,
         city: City,
         region: Region) {
        self.window = window
        self.city = city
        self.region = region
    }
    
    func start() {
        let vc = TransportsMapViewController()
        let vm = TransportsMapViewModel(output: vc,
                                        region: region,
                                        city: city,
                                        transportsFetch: TransportsFetcher(repository: TransportRepository(client: TransportsAPIClient(),
                                                                                                           mapper: AnyTransportDataModelToDomainMapper())))
//        let vm = TransportsMapViewModel(output: vc,
//                                        region: Region(minLat: 38.711046,
//                                                       minLong: -9.160096,
//                                                       maxLat: 38.739429,
//                                                       maxLong: -9.137115),
//                                        city: City(name: "Lisboa",
//                                                   centerLat: 38.736946,
//                                                   centerLon: -9.142685),
//                                        transportsFetch: TransportsFetcher(repository: TransportRepository(client: TransportsAPIClient(),
//                                                                                                           mapper: AnyTransportDataModelToDomainMapper())))
        vc.input = vm
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
    }
}
