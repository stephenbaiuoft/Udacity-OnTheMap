//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by stephen on 8/27/17.
//  Copyright © 2017 Bai Cloud Tech Co. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController {
    // MARK: Variables
    var placeMark: MKPlacemark?
    // whether previous location existed
    var existed: Bool = false
    
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var displayTextView: UITextView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      
        // Delegate Set up         
        locationTextField.delegate = self
        displayTextView.delegate = self  
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // show the default displayTextField message
        showDefaultMessage()
        // Hide the mapView
        mapView.isHidden = true
        // Additional Set up
        subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Additional Set up
        unsubscribeFromKeyboardNotifications()
    }
    
    
    // MARK: IBAction 
    
    @IBAction func cancel(sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    //
    @IBAction func findOnMap(sender: Any) {
        let button = sender as! UIButton
        if button.currentTitle == "Find on the Map" {
        
            // display mapView
            if ((locationTextField.text?.characters.count)! > 0) {
                mapView.isHidden = false
            
                locationTextField.isHidden = true
                updateSearchResults()
            } else {
                displayTextView.text = displayTextView.text! + "\n\nPlease Enter a Valid Location"
            }
        } else {
            // submit to Server
            if displayTextView.text != "" {
                Client.sharedInstance().submitToParse(hostController: self, existed: existed, completionHandlerForSubmit: { (success, errorString) in
                    if success {
                        print("successfully made POST/PUT request to PARSE")
                        // dismiss && go back!!!!
                        DispatchQueue.main.async {
                            
                            self.dismiss(animated: true, completion: nil)
                        }
                        
                    } else {
                        print("Error !!!!!!!!!!! at AddLocation VC")
                    }
                })
            } else {
                displayTextView.text = "Please enter a linkedin profile"
            }
            
        }
    }
    

    
    
    func showDefaultMessage() {
        
        let defaultString = "\nWhere are you\nstudying\ntoday"
        let defaultAttributedString = NSMutableAttributedString.init(string: defaultString)
        
        let boldAttribute = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 25),
        ]
        let normalAttribute = [
            NSFontAttributeName: UIFont.init(name: "Helvetica Neue", size: 25) ?? UIFont.init(),
            NSForegroundColorAttributeName: UIColor.gray
        ]
        
        defaultAttributedString.addAttributes(normalAttribute, range: NSRange.init(location: 0, length: 14))
        defaultAttributedString.addAttributes(boldAttribute, range: NSRange.init(location: 14, length: 9))
        defaultAttributedString.addAttributes(normalAttribute, range: NSRange.init(location: 23, length: 6))
        
        displayTextView.attributedText = defaultAttributedString
        displayTextView.textAlignment = .center
        
    }
    
    // MARK: Model Functions
    func updateSearchResults() {
        guard let mapView = mapView,
            let locationText = locationTextField.text else { return }
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = locationText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            // error is nil meaning successful responses
            if error == nil {
                guard let placeMark =  response?.mapItems[0].placemark else {
                    print( "location first placeMark: ", response?.mapItems[0].placemark ?? "no mapItem0 or I0 placemark is 0" )
                    return
                }
                DispatchQueue.main.async {
                    let annotation = MKPointAnnotation.init()
                    annotation.coordinate = placeMark.coordinate
                    mapView.addAnnotation(annotation)
                    
                    self.placeMark = placeMark
                    
                    // update displayViewText
                    self.updateDisplay()
                }
                
            } else {
                print ("upadteSearchResults: unable to find this location")
            }
        }
    }
    
    func updateDisplay() {
        // update displayTextView
        let dispString = "\n\n\nEnter a Link to Share Here"
        let textAttribute = [
            NSFontAttributeName: UIFont.init(name: "Helvetica Neue", size: 25) ?? UIFont.init(),
            NSForegroundColorAttributeName: UIColor.white
        ]
        
        let attributedText = NSAttributedString.init(string: dispString, attributes: textAttribute)
        
        displayTextView.attributedText = attributedText
        displayTextView.textAlignment = .center
        
        // update Button
        searchButton.setTitle("Submit", for: UIControlState.normal)
    }


}



extension AddLocationViewController{
    func keyboardWillShow(_ notification:Notification) {
        let keyboardHeight = getKeyboardHeight(notification)
        if (locationTextField.isEditing && view.frame.origin.y == 0){
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
