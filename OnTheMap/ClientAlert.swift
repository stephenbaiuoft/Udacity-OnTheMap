//
//  ClientAlert.swift
//  OnTheMap
//
//  Created by stephen on 8/31/17.
//  Copyright © 2017 Bai Cloud Tech Co. All rights reserved.
//

import Foundation
import UIKit

extension Client {
    
    func showAlert(hostController: UIViewController, warningMsg: String) {
        // Embed entire function to MainQueue because this method is used in many @escaping {} functions!!
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "", message: warningMsg, preferredStyle: UIAlertControllerStyle.alert)
            let dismissAction = UIAlertAction.init(title: "Okay", style: UIAlertActionStyle.cancel, handler: nil)
            alertController.addAction(dismissAction)
            
            hostController.present(alertController, animated: true, completion: nil)
        }

    }
    
    func showAlert(hostController: UIViewController, titleMsg: String, warningMsg: String) {
        
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: titleMsg, message: warningMsg, preferredStyle: UIAlertControllerStyle.alert)
            let dismissAction = UIAlertAction.init(title: "DISMISS", style: UIAlertActionStyle.cancel, handler: nil)
            alertController.addAction(dismissAction)
            
            hostController.present(alertController, animated: true, completion: nil)
        }

    }
}
