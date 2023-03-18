//
//  ScenariosVM.swift
//  ExpertSystem
//
//  Created by dilax on 2023-03-18.
//

import Foundation

class ScenariosVM: NSObject {
    
    func getdata() {

        ScenariosAPI.getScenariosData { result in
            switch result {
            case .success(let data):
                print(data)
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        CaseAPI.getCaseData(of: 1) { result in
            switch result {
            case .success(let data):
                print(data)
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
