//
//  CaseVM.swift
//  ExpertSystem
//
//  Created by Mathi on 2023-03-18.
//

import UIKit

class CaseVM: NSObject {

    // MARK: - Variables
    
    private var initialCaseId: Int?
    private var nextCaseId: Int?
    private var previousCaseId: Int?
    private var currentCase: Case?
    
    // MARK: - Configuration Helpers
    
    func getAnswersCount() -> Int {
        return currentCase?.answers?.count ?? 0
    }
    
    func getAnswer(at index: Int) -> Scenario? {
        return currentCase?.answers?[index]
    }
}

// MARK: - Get Set

extension CaseVM {
    
    // InitialCaseId
    public func setInitialCaseId(with id: Int) {
        initialCaseId = id
    }

    func getInitialCaseId() -> Int? {
        return initialCaseId
    }
    
    // NextCaseId
    public func setNextCaseId(with id: Int) {
        nextCaseId = id
    }
    
    func getNextCaseId() -> Int? {
        return nextCaseId
    }
    
    // PreviousCaseId
    public func setPreviousCaseId(with id: Int) {
        previousCaseId = id
    }
    
    func getPreviousCaseId() -> Int? {
        return previousCaseId
    }
    
    // CurrentCase
    func getCurrentCase() -> Case? {
        return currentCase
    }
}

// MARK: - GET Case Details

extension CaseVM {
    
    func getCaseInfo(caseId: Int, completion: @escaping (Bool, String?) -> Void) {
        
        CaseAPI.getCaseData(of: caseId) { [weak self] result in
            switch result {
            case .success(let cases):
                self?.currentCase = cases.first
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
