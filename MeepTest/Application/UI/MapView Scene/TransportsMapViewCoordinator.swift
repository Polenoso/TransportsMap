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
        vc.input = vm
        vm.sceneDelegate = self
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
    }
}

extension TransportsMapViewCoordinator: TransportsMapViewSceneDelegate {
    func onTransportSelected(_ transport: Transport) {
        let coordinator = TransportDetailCoordinator(fromVC: window?.rootViewController,
                                                     transport: transport)
        coordinator.start()
    }
}
