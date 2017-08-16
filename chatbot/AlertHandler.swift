//
//  AlertHandler.swift
//  chatbot
//
//  Created by 新井崚平 on 2017/08/04.
//  Copyright © 2017年 新井崚平. All rights reserved.
//

import Foundation
import UIKit

class AlertHandler {
    enum `Type` {
        case alert
        case sheet
    }
    
    class func alert(type: Type, title: String, message: String?, actionTitle: String, cancel: String? = "Cancel", actionHandler: ((UIAlertAction) -> Void)? = nil, completionHandler: @escaping ((UIAlertController) -> Void)) {
        let action = UIAlertAction(title: title, style: .default, handler: actionHandler)
        let cancel = UIAlertAction(title: cancel, style: .default, handler: actionHandler)
        switch type {
        case .alert:
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(action)
            alertController.addAction(cancel)
            completionHandler(alertController)
        case .sheet:
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            alertController.addAction(action)
            alertController.addAction(cancel)
            completionHandler(alertController)
        }
    }
}
