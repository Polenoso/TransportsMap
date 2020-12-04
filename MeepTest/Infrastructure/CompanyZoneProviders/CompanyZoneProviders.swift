//
//  CompanyZoneProviders.swift
//  MeepTest
//
//  Created by Aitor on 04/12/2020.
//

import Foundation
import UIKit

final class CompanyZoneProviders {
    private static var colorDictionary: [Int: UIColor] = [:]
    func colorForProvider(id: Int) -> UIColor {
        if let color = CompanyZoneProviders.colorDictionary[id] {
            return color
        }
        
        var newColor: UIColor = UIColor.random()
        
        while CompanyZoneProviders.colorDictionary.contains(where: { $0.value == newColor }) {
            newColor = UIColor.random()
        }
        
        CompanyZoneProviders.colorDictionary[id] = newColor
        
        return newColor
    }
}

private extension UIColor {
    static func random() -> UIColor {
        return UIColor(red: CGFloat(Int.random(in: 0..<256)/255), green: CGFloat(Int.random(in: 0..<256)/255), blue: CGFloat(Int.random(in: 0..<256)/255), alpha: 1)
    }
}
