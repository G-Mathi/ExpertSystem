//
//  Localizer.swift
//  ExpertSystem
//
//  Created by Mathi on 2023-03-18.
//

import Foundation

extension String {
    
    var localizedString: String {
        return NSLocalizedString(self, comment: "")
    }
    
    // MARK: - Alert Titles
    
    static let Alert =  NSLocalizedString("Alert", comment: "")
    static let Dismiss = NSLocalizedString("Dismiss", comment: "")
    static let Sorry = NSLocalizedString("Sorry...", comment: "")
    
    // MARK: - Alert Messages
    
    static let SomethingWentWrong = NSLocalizedString("Something went wrong...", comment: "")
    static let UpdateApp = NSLocalizedString("Please update the app to continue...", comment: "")
    
    // MARK: - Controllers
    
    static let Scenario = NSLocalizedString("Scenarios", comment: "")
    static let Case = NSLocalizedString("Case", comment: "")
    
    // MARK: - Other
    
    static let Answers = NSLocalizedString("Answers", comment: "")
    
}
