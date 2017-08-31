//
//  AddLocationDelegate.swift
//  OnTheMap
//
//  Created by stephen on 8/28/17.
//  Copyright © 2017 Bai Cloud Tech Co. All rights reserved.
//

import Foundation
import UIKit

extension AddLocationViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "Enter Your Location Here" {
            textField.text = ""
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        // not allowing to edit
        if textView.attributedText.string == "\n\n\nEnter a Link to Share Here" {
            return true
        }
        return false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "\n\n\nEnter a Link to Share Here" {
            textView.text = "\n\n\n"
        }
    }
    
}
