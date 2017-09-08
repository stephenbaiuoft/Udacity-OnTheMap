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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Properties
    var session: URLSession!
    
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        udacityLabel.adjustsFontSizeToFitWidth = true
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        activityIndicator.hidesWhenStopped = true
                
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
        
        if ((email?.isEmpty)! || (password?.isEmpty)! || !(email?.contains("@"))! ){
            Client.sharedInstance().showAlert(hostController: self, warningMsg: "Incorrect Email or Password Content")
            
        } else {
            udacityLabel.text = "Logging"
            Client.sharedInstance().authenticateWithViewController(self, completionHandlerForAuthVC: { (success, errorString) in
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                if success {
                        self.completeLogin()
                    
                } else {
                    DispatchQueue.main.async {
                        self.udacityLabel.text = errorString!
                        Client.sharedInstance().showAlert(hostController: self, warningMsg: Client.LoginError.AccountError)
                    }
                }
            })
            
            // start activityIndicator
            activityIndicator.startAnimating()
        }
    }
    
    // MARK: Login --> go to the View Controller
    private func completeLogin() {
        // completeLogin used in @escaping syntax
        DispatchQueue.main.async {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
            self.present(controller, animated: true, completion: nil)
        }
    }
}

extension LoginViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField){
        // reset label text
        udacityLabel.text = "Login to Udacity"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

