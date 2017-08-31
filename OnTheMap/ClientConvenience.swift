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
    
    func udacityLogOut(completionHandlerForLogOut: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        Client.sharedInstance().taskForDeleteSession { (result, error) in
            // result meaning data received from PARSE after Delete session!!
            if (result != nil) {
                completionHandlerForLogOut(true, nil)
            } else {
                completionHandlerForLogOut(false, error!)
            }
        }
    }
    
        
    // check if this user has previously submitted a location
    func checkSubmit( completionHandlerForCheck: @ escaping (_ ifSubmitted: Bool?, _ error: String?) -> Void ) {
        
        let parameterString = "where={\"uniqueKey\":\"\(uniqueKey!)\"}".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let methodString = ParseMethod.GetStudentLocation + "?" + parameterString!

        
        let task = taskForGetLocation (method: methodString, parameters: nil) { (data, error)
            in
            
            if error != nil {
                completionHandlerForCheck(nil, "Error converting foundation object in checkSubmit: " + (error?.localizedDescription)!)
            }
            else{
                // here parsedResult cannot be nil because of how we handled it
                let parsedResult = data as! [String: AnyObject]
                
                guard let results = parsedResult[ParseResponseKeys.Results] as? [[String: AnyObject]] else {
                    completionHandlerForCheck(nil, "Error converting mapPin results to [[String: AnyObject]]")
                    return
                }
                
                // meaning there exists mapPins created by this user already
                if results.count > 0 {
                    // getting first element supposedly
                    let parsedResult = results[0]
                    
                    guard let objectId = parsedResult[ParseResponseKeys.ObjectId] as? String else {
                        print("Error in parsing objectId")
                        return
                    }                    
                    // store the objectId
                    self.objectId = objectId
                    
                    completionHandlerForCheck(true, nil)
                } else {
                    completionHandlerForCheck(false, nil)
                }
                
            }
        }
        
    }
    
    
    
    
    // submit necessary information to PARSE SERVER
    func submitToParse( hostController: AddLocationViewController, existed: Bool, completionHandlerForSubmit: @ escaping (_ success: Bool, _ error: String?, _ annotation: MKAnnotation?) -> Void) {
        
        let lat = hostController.placeMark?.coordinate.latitude
        let long = hostController.placeMark?.coordinate.longitude
        // Need to remove newline or PARSE server will fail
        var mediaUrl = hostController.displayTextView.text!
        mediaUrl = mediaUrl.replacingOccurrences(of: "\n", with: "")
        
        let locationText = hostController.locationTextField.text!
        
        let uniqueKey = Client.sharedInstance().uniqueKey!
        let firstName = Client.sharedInstance().firstName!
        let lastName = Client.sharedInstance().lastName!
        
        // Geneaate a new annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D.init(latitude: lat!, longitude: long!)
        annotation.title = "\(firstName) \(lastName)"
        annotation.subtitle = mediaUrl
        
        // submit a new Post request
        if( !existed) {
            
            print("key:\(uniqueKey), f:\(firstName), l:\(lastName)")
            
            guard let jsonBodyData = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(locationText)\", \"mediaURL\": \"\(mediaUrl)\",\"latitude\": \(lat!), \"longitude\": \(long!)}".data(using: String.Encoding.utf8)
                else {
                    print("Failed to convert to JSON data")
                    return
                }
            let task = Client.sharedInstance().taskForModifyLocation( requestMethod: "POST", method: Client.ParseMethod.PostStudentLocation, jsonBodyData: jsonBodyData, completionHandlerForGetLocation:{
                (data, error) in
                if error != nil {
                    completionHandlerForSubmit(false, "Error occured converting foundation object", nil)
                } else {
                    completionHandlerForSubmit(true, nil, annotation)
                }
            })
        }
        
        // existed we should do Put request
        else {
            guard let jsonBodyData = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(locationText)\", \"mediaURL\": \"\(mediaUrl)\",\"latitude\": \(lat!), \"longitude\": \(long!)}".data(using: String.Encoding.utf8) else {
                
                print("Failed to convert to JSON data")
                return
                
            }
             let str = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(locationText)\", \"mediaURL\": \"\(mediaUrl)\",\"latitude\": \(lat!), \"longitude\": \(long!)}"
            
            print("jsonBodyDataStr:", str)
            
            let method = ParseMethod.PostStudentLocation + "/" + objectId!
            
            
            let task = Client.sharedInstance().taskForModifyLocation( requestMethod: "PUT", method: method, jsonBodyData: jsonBodyData, completionHandlerForGetLocation:{
                (data, error) in
                if error != nil {
                    completionHandlerForSubmit(false, "Error occured converting foundation object", nil)
                } else {
                    completionHandlerForSubmit(true, nil, annotation)
                }
            })
            
        }

                
    }
    
//  Need to separate updateMapView's data module such that the tableVC can shared as well!!!!!
    
    // data module for getting studentLocation information from PARSE
    func getStudentLocationsFromParse(completionHandlerForGetLocations: @escaping (_ success: Bool) -> Void) {
        
        let task = Client.sharedInstance().taskForGetLocation( method: ParseMethod.GetStudentLocation, parameters: nil) { (data, error) in
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
                completionHandlerForGetLocations(true)
            }
        }
        
        
    }
    
    // begin to save data to Client by receiving JSON map annotation information from PARSE
    func updateMapView(mapView: MKMapView) {
        getStudentLocationsFromParse { (success) in
            if success {
                self.updateMapPin(mapView: mapView)
            } else {
                print("Error: getting locations from PARSE")
            }
        }
        
    }
//
//    // call this function to Add a new location to MapView
//    func addMapPin(mapView: MKMapView, annotation: MKAnnotation) {
//        DispatchQueue.main.async {
//            print("Adding to the mapView for another annotation")
//            mapView.addAnnotation(annotation)
//        }
//    }
    
    
    // call this function only after self.mapPins is updated ==> Note is already called by Dispatch
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
            if mapView.annotations.count == 0{
                mapView.addAnnotations(annotations)
            }
            // need to re-update entire view
            else {
                mapView.removeAnnotations(mapView.annotations)
                mapView.addAnnotations(annotations)                
            }
        }
        
    }
    
    
    func authenticateWithViewController(_ hostViewController: LoginViewController, completionHandlerForAuthVC: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
         loginAuthentication(hostViewController, completionHandlerForAuth: { (success, errorString) in
            // success no
            if( success ){
                // now get the student information
                self.getUserData(completionHandlerForUserData: { (success, error) in
                    if success {
                        completionHandlerForAuthVC(true, nil)
                    } else {
                        completionHandlerForAuthVC(false, error)
                    }
                })
            }
            else{
                 completionHandlerForAuthVC(false, errorString)
            }
        })
    
    }
    
    func getUserData( completionHandlerForUserData: @escaping (_ success:Bool, _ errorString:String?)->Void) {
        
        let method = UdacityMethod.UdacityUserData + uniqueKey!
        let task = taskForGetMethod(method: method) { (data, error) in
            if let error = error{
                completionHandlerForUserData(false, error.localizedDescription)
            } else {
                let parsedResult = data as! [String: AnyObject]
                
                guard let userInfo = parsedResult[UResponseConstant.User] as? [String: AnyObject],
                let lastName = userInfo[UResponseConstant.lastName] as? String,
                let firstName = userInfo[UResponseConstant.firstName] as? String else {
                    completionHandlerForUserData(false, "Error parsing userInfo or lastName" )
                    return
                }
                
                // Assign the values
                self.firstName = firstName
                self.lastName = lastName
                completionHandlerForUserData(true, nil)
                
            }
        }
        
        task.resume()
        
    }
    
    // begin the Udacity login authentication process
    // in this case, only 1 post request was need lolll, which is simpler
    func loginAuthentication(_ hostViewController: LoginViewController , completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?)->Void ){
        
        let email = hostViewController.emailTextField.text!
        let password = hostViewController.passwordTextField.text!
        
        guard let jsonBodyData = "{\"\(ULoginConstant.Udacity)\": {\"\(ULoginConstant.Username)\": \"\(email)\", \"\(ULoginConstant.Password)\": \"\(password)\"}}".data(using: String.Encoding.utf8) else{
            completionHandlerForAuth(false, "Error in converting to utf8 encoded data")
            return
        }
        
        let task = Client.sharedInstance().taskForPostMethod(method: UdacityMethod.UdacitySession, jsonBodyData: jsonBodyData ) { (data, error) in
            
            if let error = error{
                completionHandlerForAuth(false, error.localizedDescription)
            } else {
                let parsedResult = data as! [String: AnyObject]
                
                guard let accountInfo = parsedResult[UResponseConstant.Account] as? [String: AnyObject],
                    let registered = accountInfo[UResponseConstant.Registered] as? Bool,
                    let uniqueKey = accountInfo[UResponseConstant.Key] as? String
                    else {
                    completionHandlerForAuth(false, "Failed to parse user account info")
                    return
                }
                // assign and store unique key for client student
                self.uniqueKey = uniqueKey
                
                guard let sessionInfo = parsedResult[UResponseConstant.Session] as? [String: AnyObject],
                    let sessionId = sessionInfo[UResponseConstant.Id] as? String else {
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
