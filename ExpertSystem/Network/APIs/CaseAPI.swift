//
//  CaseAPI.swift
//  ExpertSystem
//
//  Created by Mathi on 2023-03-18.
//

import Foundation

open class CaseAPI {
    
    public static let session = URLSession.shared
    
}

extension CaseAPI {
    
    public class func getCaseData(of id: Int, completion: @escaping (Result<[Case], RequestError>) -> Void) {
        let request = CaseAPI.getCaseInfoWithRequestBuilder(of: id)
        
        CaseAPI.getData(for: request) { result in
            completion(result)
        }
    }
}

extension CaseAPI {
    
    private class func getCaseInfoWithRequestBuilder(of id: Int) -> URLRequest? {
        return EndPoint.getCase(caseId: id).request
    }
    
    private class func getData(for request: URLRequest?, completion: @escaping (Result<[Case], RequestError>) -> Void) {
        
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
                let decodedData: [Case] = try JSONDecoder().decode([Case].self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.dataDecodingError))
            }
        }.resume()
    }
}

