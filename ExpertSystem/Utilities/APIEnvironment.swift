//
//  APIEnvironment.swift
//  ExpertSystem
//
//  Created by Mathi on 2023-03-18.
//

import Foundation

enum APIEnvironment {
    case development
    case staging
    case production
    
    static func current() -> APIEnvironment {
        return.development
    }
    
    func domain() -> String {
        switch self {
        case .development:
            return "efserver.net"
        case .staging:
            return "efserver.net"
        case .production:
            return "efserver.net"
        }
    }
    
    func subdomain() -> String {
        switch self {
        case .development, .production, .staging:
            return "mobileapi"
        }
    }
    
    func route() -> String {
        return "/mobile_api_test/"
    }
}
