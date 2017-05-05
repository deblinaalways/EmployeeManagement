//
//  AlertController.swift
//  EmployeeManagement
//
//  Created by Deblina Das on 05/05/17.
//  Copyright © 2017 Deblina Das. All rights reserved.
//

import Foundation
import UIKit

class AlertController {
    
    class func present(title: String, message: String, from presentingViewController: UIViewController? = nil, okAction: (()->Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alertAction) in okAction?() }))
        (presentingViewController ?? UIWindow.visibleViewController())?.present(alertController, animated: true, completion: nil)
    }
}
