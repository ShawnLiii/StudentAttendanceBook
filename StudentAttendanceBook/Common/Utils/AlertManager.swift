//
//  AlertManager.swift
//  StudentAttendanceBook
//
//  Created by Shawn Li on 6/6/20.
//  Copyright © 2020 ShawnLi. All rights reserved.
//

import UIKit

class AlertManager
{
    enum AlertType: String
    {
        case emptyTextField = "Names or Major can't be empty."
    }
    
    static func alert(forWhichPage viewController: UIViewController, alertType: AlertType)
    {
        var message = String()
        let title = "Warning!"
        
        switch alertType
        {
        case .emptyTextField:
            message = AlertType.emptyTextField.rawValue
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        
        alertController.addAction(alertAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}
