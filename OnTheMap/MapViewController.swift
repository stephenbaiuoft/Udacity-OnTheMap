//
//  MapViewController.swift
//  OnTheMap
//
//  Created by stephen on 8/26/17.
//  Copyright © 2017 Bai Cloud Tech Co. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    // MARK: Variable declaration
    let locationManager = CLLocationManager()
    let localSearch: MKLocalSearch! = nil
    
    var existed: Bool = false
    var annotation: MKAnnotation?
    
    // MARK: Outlet declaration
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        mapView.delegate = self
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()

        // Retriving location information
        Client.sharedInstance().updateMapView(hostController: self)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // update ClientView every single time!!!
        Client.sharedInstance().updateMapView(hostController: self)
    }
    
    @IBAction func createLocation(sender: Any) {
        // check if previous submission exists
        Client.sharedInstance().checkSubmit { (postedLocation, errorString) in
            
            // errorString not nil ==> Show UIAlert
            if errorString != nil {
                Client.sharedInstance().showAlert(hostController: self, warningMsg: errorString!)
            }
            else {
                DispatchQueue.main.async {
                    if postedLocation {
                        self.showAlertBox()
                    }
                    // No data is posted, go directly
                    else {
                        self.performSegue(withIdentifier: Client.SegueIdentifierConstant.TabMapVCToLocationVC, sender: self)
                    }
                }
            }
        }
    }
    
    // Reloads data from PARSE and then updates the map
    @IBAction func refreshMap() {
        // start activityIndicator
        activityIndicator.startAnimating()
        Client.sharedInstance().getStudentLocationsData { (success, errorString) in

            if success {
                Client.sharedInstance().updateMapView(hostController: self)
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
            } else {
                Client.sharedInstance().showAlert(hostController: self, warningMsg: errorString!)
            }
        }
        
    }
    
    @IBAction func logOut(sender: Any) {
        
            Client.sharedInstance().udacityLogOut { (success, nsError) in
                DispatchQueue.main.async {
                    if success {
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        Client.sharedInstance().showAlert(hostController: self, warningMsg: Client.ClientError.Logout)
                    }
                }
                
        }
    }
    
    
    // MARK: Back end logic function region
    
    // Show Alert UI
    func showAlertBox() {
        let alertController = UIAlertController(title: "", message: "You Have Already Posted a Student Location. Would You Like to Overwrite Your Current Location?", preferredStyle: UIAlertControllerStyle.alert)
        let overWriteAction = UIAlertAction(title: "Overwrite", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            
            // MARK: Overwrite Section on MapViewController
            Client.sharedInstance().log("Overwrite Pressed")
            self.performSegue(withIdentifier: Client.SegueIdentifierConstant.TabMapVCToLocationVC, sender: self)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
             Client.sharedInstance().log("Cancel Pressed")
        }
        
        alertController.addAction(overWriteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    // check if using Default User Location or set a default
    func setLocationAuthorization() {
        func initDefaultLocation() {
            
            let initialLocation = CLLocation(latitude: 43.65, longitude: 79.38)
            let regionRadius: CLLocationDistance = 3000
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate,
                                                                      regionRadius, regionRadius)
            mapView.setRegion(coordinateRegion, animated: true)
            Client.sharedInstance().log("finished setting up map")
        }
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse
        {
            print("is authorizationStatus ?")
            mapView.showsUserLocation = true
        }
            // Use default location
        else {
            if CLLocationManager.authorizationStatus() == .denied {
                // to be fixed later on!!!
                print("access denied nothing I can do")
            }
            
            print("requesting locationService nowwwwwwwwwwwwwwww")
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
            
            print("authorization status")
            initDefaultLocation()
            
        }
    }
    
}

// Add Observer

// Deprecated No Longer Used in the Patched Desing
//extension MapViewController {
    // note this function has to be declared here!!! Because of NSNotificationCenter add MapViewController as observer
//    
//    func addedMapPinWillShow(_ notification: NSNotification) {
//        Client.sharedInstance().log("Received a notification!")
//        // re-trieve data from PARSE again
//        Client.sharedInstance().updateMapView(hostController: self)
//        // re-move self as an observer
//        Client.sharedInstance().unsubscribeFromAddLocationViewController(chosenViewController: self)
//        Client.sharedInstance().log("Done removing MapViewController as Observer")
//    }


//}



