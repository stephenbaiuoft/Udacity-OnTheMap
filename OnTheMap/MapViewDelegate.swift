//
//  MapViewDelegate.swift
//  OnTheMap
//
//  Created by stephen on 8/28/17.
//  Copyright © 2017 Bai Cloud Tech Co. All rights reserved.
//

import Foundation
import MapKit

// MARK: Delegate Mehthods for MapViewController
extension MapViewController: MKMapViewDelegate, CLLocationManagerDelegate{
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                if let url = URL.init(string: toOpen) {
                    app.open(url, options: [:], completionHandler: { (success) in
                        if (success) {
                            print("Successfully open url")
                        } else {
                            print("Failed to open url")
                        }
                    })
                }
            }
        }
    }
    
    
    
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
}
