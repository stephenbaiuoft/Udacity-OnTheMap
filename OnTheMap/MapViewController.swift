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
    
    // MARK: Outlet declaration
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        Client.sharedInstance().updateMapView(mapView: mapView)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createLocation(sender: Any) {
        
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

// MARK: MapView Delegate Mehthods
extension MapViewController: MKMapViewDelegate{
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if (pinView == nil) {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
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
