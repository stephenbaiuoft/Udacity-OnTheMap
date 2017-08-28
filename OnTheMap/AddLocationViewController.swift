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
    
    
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var displayTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Delegate Set up 
        displayTextField.delegate = self
        locationTextField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        // display mapView
        mapView.isHidden = false
        if ((locationTextField.text?.characters.count)! > 0) {
                    updateSearchResults()
        } else {
            displayTextField.text = displayTextField.text! + "\nPlease Enter a Valid Location"
        }
        
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
                }
                
            } else {
                print ("upadteSearchResults: unable to find this location")
            }
        }
    }
    
//    func addToMap(placeMark: MKPlacemark) {
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = placeMark.coordinate
//        annotation.title = "\(first) \(last)"
//        annotation.subtitle = mediaURL
//    }
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
