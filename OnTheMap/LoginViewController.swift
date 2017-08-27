//
//  ViewController.swift
//  OnTheMap
//
//  Created by stephen on 8/24/17.
//  Copyright © 2017 Bai Cloud Tech Co. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: IBOutlets
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var udacityLoginButton: UIButton!
    @IBOutlet weak var udacityLabel: UILabel!
    
    @IBOutlet weak var facebookLoginButton: UIButton!
    
    
    // MARK: Properties
    var session: URLSession!
    
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        udacityLabel.adjustsFontSizeToFitWidth = true
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: IBActions
    @IBAction func loginUdacity(_ sender: AnyObject){
        // Check the condition for login
        let email = emailTextField.text
        let password = passwordTextField.text
        
        if ((email?.isEmpty)! || (password?.isEmpty)!){
            udacityLabel.text = "Cannot Login: Email or Password is Empty"
            
        } else {
            udacityLabel.text = "Logging"
            Client.sharedInstance().loginAuthentication(email: email!, password: password!, completionHandlerForAuth: { (success, errorString) in
                // success no
                if( !success ){
                    // now update the view using mainQueue
                    DispatchQueue.main.async(execute: { 
                        self.udacityLabel.text = errorString!
                    })
                }
                else{
                    // completionHandlerForAuth needs to be passed to mainQueue
                    DispatchQueue.main.async(execute: {
                        self.completeLogin()
                    })
                }
            })
       
        }
        // if true call loginAuthentication
    }
    
    // MARK: Login --> go to the View Controller
    private func completeLogin() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
        present(controller, animated: true, completion: nil)
    }
}

extension LoginViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField){
        // reset label text
        udacityLabel.text = "Login to Udacity"
    }
}

