//
//  AlertProvider.swift
//  ExpertSystem
//
//  Created by Mathi on 2023-03-18.
//

import UIKit

public struct AlertAction {
    var title: String?
    var style: UIAlertAction.Style = .default
}

open class AlertProvider {
    
    open class func showAlert(target: UIViewController, title: String?, message: String, action: AlertAction) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: action.title, style: action.style, handler: nil))
        
        target.present(alertController, animated: true, completion: nil)
    }
    
    open class func showAlertWithActions(target: UIViewController, title: String?, message: String, actions: [AlertAction], completion: @escaping ((_ action: UIAlertAction) -> Void)) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        actions.forEach({ action in
            let _action = UIAlertAction(title: action.title, style: action.style) { (action: UIAlertAction) in
                completion(action)
            }
            alertController.addAction(_action)
        })
        
        target.present(alertController, animated: true, completion: nil)
    }
}


