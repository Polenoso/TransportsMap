//
//  Endpoint.swift
//  MeepTest
//
//  Created by Aitor on 03/12/2020.
//

import Foundation
import Moya

enum TransportsEndpointCollection {
    case all(request: TransportRequestV1)
}

extension TransportsEndpointCollection: TargetType {
    var baseURL: URL {
        guard let url = URL(string:"https://apidev.meep.me/tripplan/api") else { //TODO: read from configuration
            fatalError("there must be a valid baseUrl")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .all(request: let request):
            return "v1/routers/\(request.city.lowercased())/resources"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .all(request: _):
            return .get
        }
    }
    
    var sampleData: Data {
        Data() // TODO: implement valid data
    }
    
    var task: Task {
        switch self {
        case .all(request: let request):
            return .requestParameters(parameters:
                                        [
                                            "lowerLeftLatLon": "\(request.lowerLeftLatLong.0),\(request.lowerLeftLatLong.1)",
                                            "upperRightLatLon": "\(request.upperRightLatLong.0),\(request.upperRightLatLong.1)"
                                        ],
                                      encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        ["Content-Type": "application/json"]
    }
}
