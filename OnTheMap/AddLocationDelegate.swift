//
//  AddLocationDelegate.swift
//  OnTheMap
//
//  Created by stephen on 8/28/17.
//  Copyright © 2017 Bai Cloud Tech Co. All rights reserved.
//

import Foundation
import UIKit

extension AddLocationViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.text == "Enter Your Location Here" ) {
            textField.text = ""
        }
        
        
    }
    
}
