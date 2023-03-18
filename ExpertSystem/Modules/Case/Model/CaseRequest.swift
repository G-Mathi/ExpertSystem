//
//  CaseRequest.swift
//  ExpertSystem
//
//  Created by Mathi on 2023-03-18.
//

import Foundation

// MARK: - Case Info

public struct Case: Codable {
    var id: Int?
    var text: String?
    var image: String?
    var answers: [Scenario]?
}
