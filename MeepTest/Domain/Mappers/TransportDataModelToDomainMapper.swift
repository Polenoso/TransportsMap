//
//  TransportDataModelToDomainMapper.swift
//  MeepTest
//
//  Created by Aitor on 01/12/2020.
//

import Foundation

protocol TransportDataModelToDomainMapping {
    func map(_ dataModel: [TransportDataModelV1]) -> [Transport]
}
