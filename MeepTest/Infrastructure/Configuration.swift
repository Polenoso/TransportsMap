//
//  Configuration.swift
//  MeepTest
//
//  Created by Aitor on 03/12/2020.
//

import Foundation

@propertyWrapper
struct Environment {
    var wrappedValue: Configuration {
        #if DEBUG // NOTE: This would depend on the target
        return BetaConfiguration()
        #else
        return ProductionConfiguration()
        #endif
    }
    
    init() { }
}

protocol Configuration {
    var baseUrl: String { get }
}

struct ProductionConfiguration: Configuration {
    var baseUrl: String { "https://apidev.meep.me/tripplan/api" }
}

struct BetaConfiguration: Configuration {
    var baseUrl: String { "https://apidev.meep.me/tripplan/api" }
}
