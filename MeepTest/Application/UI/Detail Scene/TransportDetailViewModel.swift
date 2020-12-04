//
//  TransportDetailViewModel.swift
//  MeepTest
//
//  Created by Aitor on 04/12/2020.
//

import Foundation

protocol TransportDetailInput {
    var viewState: TransportDetailViewState { get }
    func onCloseTap()
}

protocol TransportDetailOutput: AnyObject { }

final class TransportDetailViewModel: TransportDetailInput {
    //MARK: - View State
    var viewState: TransportDetailViewState { .init(name: transport.name,
                                                    latitude: "\(transport.positionX)",
                                                    longitude: "\(transport.positionY)") }
    
    //MARK: - Private
    private let transport: Transport
    
    //MARK: - Scene Delegate
    private var sceneDelegate: TransportDetailSceneDelegate?
    
    init(sceneDelegate: TransportDetailSceneDelegate?,
         transport: Transport) {
        self.transport = transport
        self.sceneDelegate = sceneDelegate
    }
    
    func onCloseTap() {
        sceneDelegate?.onClose()
    }
}
