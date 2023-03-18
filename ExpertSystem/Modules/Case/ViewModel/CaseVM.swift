//
//  CaseVM.swift
//  ExpertSystem
//
//  Created by Mathi on 2023-03-18.
//

import UIKit

class CaseVM: NSObject {

    // MARK: - Variables
    
    private var selectedCaseId: Int?
    private var selectedCase: Case?
    
    public func setCaseId(with id: Int) {
        selectedCaseId = id
    }
    
    func getSelectedCase() -> Case? {
        return selectedCase
    }
    
    func getAnswersCount() -> Int {
        return selectedCase?.answers?.count ?? 0
    }
    
    func getAnswer(at index: Int) -> Scenario? {
        return selectedCase?.answers?[index]
    }
}

// MARK: - GET Case Details

extension CaseVM {
    
    func getCaseInfo(completion: @escaping (Bool, String?) -> Void) {
        
        guard let selectedCaseId else {
            completion(false, "No id found")
            return
        }
        
        CaseAPI.getCaseData(of: selectedCaseId) { [weak self] result in
            switch result {
            case .success(let cases):
                self?.selectedCase = cases.first
                completion(true, nil)
                
            case .failure(let error):
                let message: String?
                switch error {
                case .invalidRequest:
                    message = "Please update the app to continue..."
                case .clientError, .serverError, .noData, .dataDecodingError:
                    message = "Please try again later..."
                }
                completion(false, message)
            }
        }
    }
}
