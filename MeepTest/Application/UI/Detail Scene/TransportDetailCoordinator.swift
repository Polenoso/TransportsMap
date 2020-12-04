//
//  TransportDetailCoordinator.swift
//  MeepTest
//
//  Created by Aitor on 04/12/2020.
//

import UIKit

final class TransportDetailCoordinator: Coordinator {
    private weak var fromVC: UIViewController?
    private let transport: Transport
    
    init(fromVC: UIViewController?,
         transport: Transport) {
        self.fromVC = fromVC
        self.transport = transport
    }
    func start() {
        let vc = TransportDetailViewController()
        let vm = TransportDetailViewModel(transport: transport)
        vc.input = vm
        
        fromVC?.present(vc, animated: true)
    }
}
