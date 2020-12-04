//
//  AppDelegate.swift
//  MeepTest
//
//  Created by Aitor on 30/11/2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let coordinator = TransportsMapViewCoordinator(window: window,
                                                       city: City(name: "Lisboa",
                                                                  centerLat: 38.736946,
                                                                  centerLon: -9.142685),
                                                       region: Region(minLat: 38.711046,
                                                                      minLong: -9.160096,
                                                                      maxLat: 38.739429,
                                                                      maxLong: -9.137115))
        coordinator.start()
        return true
    }
}

