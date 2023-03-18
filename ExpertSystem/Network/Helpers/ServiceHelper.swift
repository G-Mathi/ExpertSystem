//
//  ServiceHelper.swift
//  ExpertSystem
//
//  Created by Mathi on 2023-03-18.
//

import Foundation

// MARK: - Request Error

public enum RequestError: Error {
    case invalidRequest
    case clientError
    case serverError
    case noData
    case dataDecodingError
    case internetNotAvailable
}

// MARK: - HTTP

enum HTTP {
    enum Scheme: String {
        case http = "http"
        case https = "https"
    }
    
    enum Method: String {
        case get = "GET"
        case post = "POST"
    }
    
    enum Header {
        enum Field: String {
            case contentType = "Content-Type"
        }
        
        enum Value: String {
            case json = "application/json"
        }
    }
}


// MARK: - Set Header

extension URLRequest {
    mutating func addValues() {
        setValue(
            HTTP.Header.Value.json.rawValue,
            forHTTPHeaderField: HTTP.Header.Field.contentType.rawValue
        )
    }
}
