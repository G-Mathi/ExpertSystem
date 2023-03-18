//
//  ExpertSystemTests.swift
//  ExpertSystemTests
//
//  Created by Mathi on 2023-03-18.
//

import XCTest
@testable import ExpertSystem

final class ExpertSystemTests: XCTestCase {

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }
    
    func testGetScenarios() {
        let scenarioSample = Scenario(caseId: 1, text: "Power button will not start computer")
        
        let expectation = self.expectation(description: "Scenaio_API")
        
        ScenariosAPI.getScenariosData { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data[0].text, scenarioSample.text)
                expectation.fulfill()
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        waitForExpectations(timeout: 5)
    }
}
