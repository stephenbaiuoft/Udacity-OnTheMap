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
    
    func showAlert(hostController: UIViewController, warningMsg: String, action1Msg: String?, action2Msg: String?) {
        let alertController = UIAlertController(title: "", message: warningMsg, preferredStyle: UIAlertControllerStyle.alert)
        if action1Msg != nil {
            let action1 = UIAlertAction.init(title: action1Msg!, style: UIAlertActionStyle.default, handler: nil)
            alertController.addAction(action1)
        }
        if action2Msg != nil {
            let action2 = UIAlertAction(title: action2Msg!, style: UIAlertActionStyle.default, handler: nil)
            alertController.addAction(action2)
        }
        
        
        let dismissAction = UIAlertAction.init(title: "Okay", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(dismissAction)
    
        hostController.present(alertController, animated: true, completion: nil)
    }
    
}
