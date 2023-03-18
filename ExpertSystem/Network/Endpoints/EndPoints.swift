//
//  EndPoints.swift
//  ExpertSystem
//
//  Created by Mathi on 2023-03-18.
//

import Foundation

enum EndPoint {
    case getScenarios(path: String = "scenarios", queryItems: [URLQueryItem]? = nil)
    case getCase(path: String = "scenarios/cases/", queryItems: [URLQueryItem]? = nil)
    
    var request: URLRequest? {
        guard let url = url else { return nil }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = httpMethod
        request.addValues()
        
        return request
    }
    
    private var url: URL? {
        var components = URLComponents()
        
        components.scheme = HTTP.Scheme.https.rawValue
        components.host = host
        components.path = path
        components.queryItems = queryItems
        
        return components.url
    }
    
    private var host: String {
        let domain = APIEnvironment.current().domain()
        let subDomain = APIEnvironment.current().subdomain()
        return "\(subDomain).\(domain)"
    }
    
    private var path: String {
        let route = APIEnvironment.current().route()
        switch self {
        case .getScenarios(let path, _):
            return route + path
        case .getCase(let path, _):
            return route + path
        }
    }
    
    private var httpMethod: String {
        switch self {
        case .getScenarios:
            return HTTP.Method.get.rawValue
        case .getCase:
            return HTTP.Method.get.rawValue
        }
    }
    
    private var queryItems: [URLQueryItem]? {
        switch self {
        case .getScenarios:
            return nil
        case .getCase:
            return nil
        }
    }
}

