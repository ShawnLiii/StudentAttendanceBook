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
        case operationGuide = "Please add student infomation by tapping the \"+\" icon on the right top.\nSwipe down to use the search bar."
    }
    
    static func alert(forWhichPage viewController: UIViewController, alertType: AlertType)
    {
        var message = String()
        var title = "Warning!"
        var style: UIAlertController.Style = .alert
        
        switch alertType
        {
        case .emptyTextField:
            message = AlertType.emptyTextField.rawValue
        case .operationGuide:
            message = AlertType.operationGuide.rawValue
            title = "Reminder"
            style = .actionSheet
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        
        alertController.addAction(alertAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}
