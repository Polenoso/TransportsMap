//
//  TransportDetailViewModel.swift
//  MeepTest
//
//  Created by Aitor on 04/12/2020.
//

import Foundation

protocol TransportDetailInput {
    var viewState: TransportDetailViewState { get }
}

protocol TransportDetailOutput: AnyObject { }

final class TransportDetailViewModel: TransportDetailInput {
    //MARK: - View State
    var viewState: TransportDetailViewState { .init(name: transport.name,
                                                    latitude: "\(transport.positionX)",
                                                    longitude: "\(transport.positionY)") }
    
    //MARK: - Private
    private let transport: Transport
    
    init(transport: Transport) {
        self.transport = transport
    }
}
