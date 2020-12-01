//
//  AnyTransportDataModelMapper.swift
//  MeepTest
//
//  Created by Aitor on 01/12/2020.
//

import Foundation

final class AnyTransportDataModelToDomainMapper: TransportDataModelToDomainMapping {
    func map(_ dataModel: [TransportDataModelV1]) -> [Transport] {
        dataModel.map({AnyTransport(id: $0.id,
                                    name: $0.name,
                                    positionX: $0.positionX,
                                    positionY: $0.positionY,
                                    companyZoneId: $0.companyZoneId)})
    }
}
