//
//  ScenariosRequest.swift
//  ExpertSystem
//
//  Created by Mathi on 2023-03-18.
//

import Foundation

// MARK: - Scenario Info

public struct Scenario: Codable {
    var caseId: Int?
    var text: String?
    
    enum CodingKeys: String, CodingKey {
        case caseId = "caseid"
        case text
    }
}
