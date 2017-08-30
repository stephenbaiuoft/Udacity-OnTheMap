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
    let gotoAddLocationIdentifier = "addLocationIdentifier"
    var existed: Bool = false
    
    // MARK: Outlet declaration
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        mapView.delegate = self

        // Retriving location information
        Client.sharedInstance().updateMapView(mapView: mapView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createLocation(sender: Any) {
        // check if previous submission exists
        Client.sharedInstance().checkSubmit { (existed, error) in
            if existed == nil {
                print("Error in Processing Get Location")
            }
            else {
                if existed! {
                    // set existed as true
                    self.existed = true
                    DispatchQueue.main.async {
                        self.showAlert()
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: self.gotoAddLocationIdentifier, sender: self)
                    }
                }                
            }

        }
        
    }
    
    
    // MARK: Segue Region
    
    // handle necessary information
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == gotoAddLocationIdentifier){
            let controller = segue.destination as! AddLocationViewController
            controller.existed = existed
        }
    }

    
    
    // MARK: Back end logic function region
    
    // Show Alert UI
    func showAlert() {
        let alertController = UIAlertController(title: "", message: "You Have Already Posted a Student Location. Would You Like to Overwrite Your Current Location?", preferredStyle: UIAlertControllerStyle.alert)
        let overWriteAction = UIAlertAction(title: "Overwrite", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            print("Overwrite Pressed")
            
            // go overwrite now
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: self.gotoAddLocationIdentifier, sender: self)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
            print("Cancel Pressed")
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
            print("finished setting up map")
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


