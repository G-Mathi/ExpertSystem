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
    
    static let Alert =  NSLocalizedString("Alert", comment: "")
    static let Dismiss = NSLocalizedString("Dismiss", comment: "")
    static let Sorry = NSLocalizedString("Sorry...", comment: "")
}
