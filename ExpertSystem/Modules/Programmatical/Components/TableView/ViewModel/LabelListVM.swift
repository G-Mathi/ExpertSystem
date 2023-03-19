//
//  LabelListVM.swift
//  ExpertSystem
//
//  Created by Mathi on 2023-03-19.
//

import Foundation

class LabelListVM: NSObject {
    
    // MARK: - Variables
    
    private var model: [String]?
    
    // Set Model
    public func setModel(with id: [String]) {
        model = id
    }
    
    // MARK: - Configuration Helpers

    func getModelCount() -> Int {
        return model?.count ?? 0
    }
    
    func getElement(at index: Int) -> String? {
        return model?[index]
    }
}
