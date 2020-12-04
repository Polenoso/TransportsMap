//
//  MapViewSceneDelegate.swift
//  MeepTest
//
//  Created by Aitor on 04/12/2020.
//

import Foundation

protocol TransportsMapViewSceneDelegate: AnyObject {
    func onTransportSelected(_ transport: Transport)
}
