//
//  ScenariosVM.swift
//  ExpertSystem
//
//  Created by Mathi on 2023-03-18.
//

import Foundation

class ScenariosVM: NSObject {
    
    // MARK: - Variables
    
    private var scenarios: [Scenario]?
    
    func getScenarios() -> [Scenario]? {
        return scenarios
    }
    
    func getScenariosCount() -> Int {
        return scenarios?.count ?? 0
    }
    
    func getScenario(at index: Int) -> Scenario? {
        return scenarios?[index]
    }
}

// MARK: - GET Scenarios

extension ScenariosVM {
    
    func getScenarios(completion: @escaping (Bool, String?) -> Void) {
        ScenariosAPI.getScenariosData { [weak self] result in
            switch result {
            case .success(let scenarios):
                self?.scenarios = scenarios
                completion(true, nil)
                
            case .failure(let error):
                let message: String?
                switch error {
                case .invalidRequest:
                    message = .UpdateApp
                case .clientError, .serverError, .noData, .dataDecodingError:
                    message = .SomethingWentWrong
                case .internetNotAvailable:
                    message = .NoInternet
                }
                completion(false, message)
            }
        }
    }
}
