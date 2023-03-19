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
    
    // MARK: API Test - GET Scenarios
    
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
    
    // MARK: API Test - GET Cases
    
    func testGetCase() {
        let caseSample = Case(id: 1, text: "check the power cord to confirm that it is plugged securely into the back of the computer")
        
        let expectation = self.expectation(description: "Case_API")
        
        CaseAPI.getCaseData(of: 1) { result in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
                XCTAssertEqual(data[0].text, caseSample.text)
                expectation.fulfill()
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        waitForExpectations(timeout: 5)
    }
}
