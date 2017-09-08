//
//  SubmitLocationViewController.swift
//  OnTheMap
//
//  Created by stephen on 9/1/17.
//  Copyright © 2017 Bai Cloud Tech Co. All rights reserved.
//

import UIKit
import MapKit

class SubmitLocationViewController: UIViewController {
    // MARK: Variable Declarion Region
    
    // MARK: Outlet Regions
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var webUrlTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        activityIndicator.hidesWhenStopped = true
        // Delegate
        locationTextField.delegate = self
        webUrlTextField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: IBAction Section
    
    @IBAction func cancel(sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocation(sender: Any) {
        // this function updates ClientVariables
        func updateClientVariables(mkPlaceMark: MKPlacemark ) {
            Client.sharedInstance().searchedPlaceMark = mkPlaceMark
            Client.sharedInstance().addedWebUrl = self.webUrlTextField.text!
            Client.sharedInstance().mapLocationString = self.locationTextField.text!
        }
        
        
        if (locationTextField.text == "") {
            Client.sharedInstance().showAlert(hostController: self, titleMsg: Client.AddLocationError.LocationTitle, warningMsg: Client.AddLocationError.LocationEmptyMsg)
        } else if (webUrlTextField.text == "") {
            Client.sharedInstance().showAlert(hostController: self, titleMsg: Client.AddLocationError.LocationTitle, warningMsg: Client.AddLocationError.URLEmptyMsg)
        } else {
            // I will append https: by default
            var url = webUrlTextField.text!
            if !url.contains("http") {
                url = "https://" + url
            }
            //
            activityIndicator.startAnimating()
            findLocationOnMap(completionHandlerForFindLocation: { (success, mkPlaceMark) in
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                if success {
                    // saves the troulbe of passing through prepare segue loll
                    updateClientVariables(mkPlaceMark: mkPlaceMark!)
                    
                    // go to the viewController with mapView
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: Client.SegueIdentifierConstant.LocationVCToMapViewVC, sender: self)
                    }
                    
                } else {                    
                        Client.sharedInstance().showAlert(hostController: self, titleMsg: Client.AddLocationError.LocationTitle, warningMsg: Client.AddLocationError.LocationNotFoundMsg)
                    
                }
            })
            
            
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}

// MARK: Back-end functions for View Controller 
extension SubmitLocationViewController {
    
    // Function to find placeMark information based on user input
    func findLocationOnMap(completionHandlerForFindLocation: @escaping(_ success: Bool, _ data: MKPlacemark?) -> Void) {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = locationTextField.text!

        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            // error is nil meaning successful responses
            if error == nil {
                // Also get the first suggestion
                guard let placeMark =  response?.mapItems[0].placemark else {
                    Client.sharedInstance().log( "location first placeMark: ", response?.mapItems[0].placemark ?? "no mapItem0 or I0 placemark is invalid" as AnyObject )
                    completionHandlerForFindLocation( false, nil )
                    return
                }
                completionHandlerForFindLocation(true, placeMark)
            }
                
            // Unable to find results
            else {
                completionHandlerForFindLocation(false, nil)
            }
            
                
        }
    }
        
}


// MARK: Notification Segment
extension SubmitLocationViewController {
    func keyboardWillShow(_ notification:Notification) {
        let keyboardHeight = getKeyboardHeight(notification)
        if ( (locationTextField.isEditing || webUrlTextField.isEditing) && view.frame.origin.y == 0){
            // shifting upwards, from 0 to keybaord height
            view.frame.origin.y = -keyboardHeight
        }
    }
    
    func keyboardWillHide(_ notification: Notification){
        view.frame.origin.y = 0
    }
    
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
}
