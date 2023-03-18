//
//  ScenariosAPI.swift
//  ExpertSystem
//
//  Created by Mathi on 2023-03-18.
//

import Foundation

class ScenariosAPI {
    
    public static let session = URLSession.shared
    
}

extension ScenariosAPI {
    
    public class func getScenariosData(completion: @escaping (Result<[Scenario], RequestError>) -> Void) {
        let request = ScenariosAPI.getScenariosWithRequestBuilder()
        
        ScenariosAPI.getData(for: request) { result in
            completion(result)
        }
    }
}

extension ScenariosAPI {
    
    private class func getScenariosWithRequestBuilder() -> URLRequest? {
        return EndPoint.getScenarios().request
    }
    
    private class func getData(for request: URLRequest?, completion: @escaping (Result<[Scenario], RequestError>) -> Void) {
        
        guard Availablity.isInternetAvailable() else {
            completion(.failure(.internetNotAvailable))
            return
        }
        
        guard let request else {
            completion(.failure(.invalidRequest))
            return
        }
        
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.clientError))
                return
            }
            
            guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                completion(.failure(.serverError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decodedData: [Scenario] = try JSONDecoder().decode([Scenario].self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.dataDecodingError))
            }
        }.resume()
    }
}

