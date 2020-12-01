//
//  JsonLoader.swift
//  MeepTestTests
//
//  Created by Aitor on 01/12/2020.
//

import Foundation

final class JsonLoader: NSObject {
    class func jsonDataNamed(_ name: String) -> Data {
        let bundle = Bundle(for: self)
        let path = bundle.path(forResource: name, ofType: "json")!
        let url = URL(fileURLWithPath: path)
        if !FileManager.default.fileExists(atPath: path) {
            debugPrint("\nError loading json at: \(path)\n")
        }

        return (try! Data(contentsOf: url))
    }
}
