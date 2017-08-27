//
//  ClientConvenience.swift
//  OnTheMap
//
//  Created by stephen on 8/25/17.
//  Copyright © 2017 Bai Cloud Tech Co. All rights reserved.
//

import Foundation
import MapKit

// More Advanced Model Functions that build on Client
extension Client{
    
    // begin to save data to Client by receiving JSON map annotation information from PARSE
    func updateMapView(mapView: MKMapView) {
        // automatically updates
        let task = Client.sharedInstance().taskForGetLocation(parameters: nil) { (data, error) in
            // an error occured
            func displayError(_ error: String) {
                print("Error in updateMapPin: " + error)
            }
            
            if error != nil {
                displayError("Error converting foundation object: " + (error?.localizedDescription)!)
            }
            else{
                // here parsedResult cannot be nil because of how we handled it
                let parsedResult = data as! [String: AnyObject]
                
                guard let mapPinResults = parsedResult[ParseResponseKeys.Results] as? [[String: AnyObject]] else {
                    displayError("Error converting mapPin results to [[String: AnyObject]]")
                    return
                }
                
                // update Client mapPins data here
                self.mapPins = MapPin.locationsFromResults(results: mapPinResults)
                
                // now update MapPin in MapView
                self.updateMapPin(mapView: mapView)
                
            }
            
        }
    }
    
    // call this function only after self.mapPins is updated
    private func updateMapPin(mapView: MKMapView) {
        var annotations = [MKPointAnnotation]()
        
        for mapPin in self.mapPins!{
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(mapPin.latitude)
            let long = CLLocationDegrees(mapPin.longtitude)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = mapPin.firstName
            let last = mapPin.lastName
            let mediaURL = mapPin.mediaURL
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        //MKPointAnnotation()
        DispatchQueue.main.async {
            print("adding to Queue to Update to annotations")
            mapView.addAnnotations(annotations)
        }
        
        
    }
    
    // begin the Udacity login authentication process
    // in this case, only 1 post request was need lolll, which is simpler
    func loginAuthentication( email: String, password: String, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?)->Void ){
        
        guard let jsonBodyData = "{\"\(ULoginConstant.Udacity)\": {\"\(ULoginConstant.Username)\": \"\(email)\", \"\(ULoginConstant.Password)\": \"\(password)\"}}".data(using: String.Encoding.utf8) else{
            completionHandlerForAuth(false, "Error in converting to utf8 encoded data")
            return
        }
        
        let task = Client.sharedInstance().taskForPostMethod(method: UdacityMethod.UdacitySession , parameters: [:] as [String: String], jsonBodyData: jsonBodyData ) { (data, error) in
            
            if let error = error{
                completionHandlerForAuth(false, error.localizedDescription)
            } else {
                let parsedResult = data as! [String: AnyObject]
                
                guard let accountInfo = parsedResult[UResponseConstant.Account] as? [String: AnyObject],
                    let registered = accountInfo[UResponseConstant.Registered] as? Bool else {
                    completionHandlerForAuth(false, "Failed to parse user account info")
                    return
                }
                
                guard let sessionInfo = parsedResult[UResponseConstant.Session] as? [String: AnyObject],
                    let sessionId = sessionInfo[UResponseConstant.Id] as? String else{
                        completionHandlerForAuth(false, "Failed to parse user session info")
                        return
                }
                
                if (registered){
                    // assign sessionId
                    self.sessionId = sessionId
                    completionHandlerForAuth(true, nil)
                }
                else {
                    completionHandlerForAuth(false, "User not registered on Udacity")
                    return
                }
                
            }
        }
        
        
    }

}
