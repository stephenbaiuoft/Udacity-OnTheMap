//
//  ClientConvenience.swift
//  OnTheMap
//
//  Created by stephen on 8/25/17.
//  Copyright © 2017 Bai Cloud Tech Co. All rights reserved.
//

import Foundation
import MapKit

// This file is responsible for higher-level handling of urlTaskMethods
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
    func checkSubmit( completionHandlerForCheck: @ escaping (_ postedLocation: Bool, _ error: String?) -> Void ) {
        
        let parameterString = "where={\"uniqueKey\":\"\(uniqueKey!)\"}".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let methodString = ParseMethod.GetStudentLocation + "?" + parameterString!
        
        // parametersUrl is "" because not getting locations of all student
        let task = taskForGetLocation (method: methodString, parametersUrl: "") { (data, error)
            in
            
            if error != nil {
                completionHandlerForCheck(false, JSONConversionError.JSONToFoundation + (error?.localizedDescription)!)
            }
            else{
                // here parsedResult cannot be nil because of how we handled it
                let parsedResult = data as! [String: AnyObject]
                
                guard let results = parsedResult[ParseResponseKeys.Results] as? [[String: AnyObject]] else {
                    completionHandlerForCheck(false, JSONConversionError.JSONToDicAry)
                    return
                }
                
                // meaning there exists mapPins created by this user already
                if results.count > 0 {
                    // getting first element supposedly
                    let parsedResult = results[0]
                    
                    guard let objectId = parsedResult[ParseResponseKeys.ObjectId] as? String else {
                        completionHandlerForCheck(false, UdacityAccountError.ObjectId)
                        return
                    }
                    
                    // Update Client variables
                    self.objectId = objectId
                    self.postedLocation = true
                    
                    
                    completionHandlerForCheck(true, nil)
                } else {
                    completionHandlerForCheck(false, nil)
                }
                
            }
        }
        
    }
    
    
    
    
    // submit necessary information to PARSE SERVER
    func submitToParse( hostController: DetailedMapViewController, completionHandlerForSubmit: @ escaping (_ success: Bool, _ error: String?) -> Void) {
        
        let lat = Client.sharedInstance().searchedPlaceMark?.coordinate.latitude
        let long = Client.sharedInstance().searchedPlaceMark?.coordinate.longitude
        
        // Need to remove newline or PARSE server will fail
        let mediaUrl = Client.sharedInstance().addedWebUrl!
        let locationText = Client.sharedInstance().mapLocationString!
        
        let uniqueKey = Client.sharedInstance().uniqueKey!
        let firstName = Client.sharedInstance().firstName!
        let lastName = Client.sharedInstance().lastName!
        
        // submit a new Post request
        if(!self.postedLocation) {
            
            print("key:\(uniqueKey), f:\(firstName), l:\(lastName)")
            
            guard let jsonBodyData = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(locationText)\", \"mediaURL\": \"\(mediaUrl)\",\"latitude\": \(lat!), \"longitude\": \(long!)}".data(using: String.Encoding.utf8)
                else {
                    print("Failed to convert to JSON data")
                    return
                }
            let task = Client.sharedInstance().taskForModifyLocation( requestMethod: "POST", method: Client.ParseMethod.PostStudentLocation, jsonBodyData: jsonBodyData, completionHandlerForGetLocation:{
                (data, error) in
                if error != nil {
                    completionHandlerForSubmit(false, "Error occured converting foundation object")
                } else {
                    completionHandlerForSubmit(true, nil)
                }
            })
        }
        
        // existed we should do Put request
        else {
            guard let jsonBodyData = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(locationText)\", \"mediaURL\": \"\(mediaUrl)\",\"latitude\": \(lat!), \"longitude\": \(long!)}".data(using: String.Encoding.utf8) else {
                print("Failed to convert to JSON data")
                return
                
            }
            
            let method = ParseMethod.PostStudentLocation + "/" + objectId!
            
            
            let task = Client.sharedInstance().taskForModifyLocation( requestMethod: "PUT", method: method, jsonBodyData: jsonBodyData, completionHandlerForGetLocation:{
                (data, error) in
                if error != nil {
                    completionHandlerForSubmit(false, "Error occured converting foundation object")
                } else {
                    completionHandlerForSubmit(true, nil)
                }
            })
            
        }

                
    }
    
//  Need to separate updateMapView's data module such that the tableVC can shared as well!!!!!
    
    // data module for getting studentLocation information from PARSE
    // call this during Login process: s.t. mapViewVC && tableViewVC can use data safely!!
    func getStudentLocationsData(completionHandlerForGetLocations: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        let parametersUrl = "?limit=100&order=-updatedAt"
        let task = Client.sharedInstance().taskForGetLocation( method: ParseMethod.GetStudentLocation, parametersUrl: parametersUrl) { (data, error) in
            
            if error != nil {
                completionHandlerForGetLocations(false, error?.localizedDescription)
            }
            else{
                // here parsedResult cannot be nil because of how we handled it
                let parsedResult = data as! [String: AnyObject]
                
                guard let studentLocationsResults = parsedResult[ParseResponseKeys.Results] as? [[String: AnyObject]] else {
                    completionHandlerForGetLocations(false, JSONConversionError.JSONToDicAry)
                    return
                }
                
                // Debug
                self.log("Received # of studentLocations: ", studentLocationsResults.count as AnyObject)
                
                // update Client mapPins data here
                self.studentInformationSet = StudentInformation.infoFromResults(results: studentLocationsResults)
                completionHandlerForGetLocations(true, nil)
            }
        }
    }
    
    
    // begin to save data to Client by receiving JSON map annotation information from PARSE
    func updateMapView(hostController: MapViewController) {
        
            self.updateMapPin(mapView: hostController.mapView)
    }
    
    // call this function only after updating studentLocationSet is updated ==> Note is already called by Dispatch
    private func updateMapPin(mapView: MKMapView) {
        var annotations = [MKPointAnnotation]()
        
        for studentInfo in self.studentInformationSet!{
            annotations.append(studentInfo.annotation)
        }
        //MKPointAnnotation()
        DispatchQueue.main.async {
            self.log("adding to Queue to Update to annotations", nil)
            
            if mapView.annotations.count == 0 {
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
                
                // Second Step: now get user Account information
                self.getUserData(uniqueKey: self.uniqueKey!, completionHandlerForUserData: { (success, error) in
                    if success {
                        
                        // Third Step: now get studentLocations Information ==> to be used for ViewControllers
                        self.getStudentLocationsData(completionHandlerForGetLocations: { (success, errorString) in
                            if success {
                                completionHandlerForAuthVC(true, nil)
                            }
                            else {
                                completionHandlerForAuthVC(false, errorString!)
                            }
                            
                        })
                    }
                        
                    else {
                        completionHandlerForAuthVC(false, error!)
                    }
                })
                
                // loginAuthentication will assign uniqueKey with value
                //self.getUserData(uniqueKey: self.uniqueKey!,completionHandlerForUserData: completionHandlerForAuthVC)
                
            }
            else{
                 completionHandlerForAuthVC(false, errorString)
            }
        })
    
    }
    
    func getUserData(uniqueKey: String ,completionHandlerForUserData: @escaping (_ success:Bool, _ errorString:String?)->Void) {
        
        let method = UdacityMethod.UdacityUserData + uniqueKey
        let task = taskForGetMethod(method: method) { (data, error) in
            if let error = error{
                completionHandlerForUserData(false, error.localizedDescription)
                return
            } else {
                let parsedResult = data as! [String: AnyObject]
                
                guard let userInfo = parsedResult[UResponseConstant.User] as? [String: AnyObject],
                let lastName = userInfo[UResponseConstant.lastName] as? String,
                let firstName = userInfo[UResponseConstant.firstName] as? String else {
                    completionHandlerForUserData(false, UdacityAccountError.UserInfo + " or " + UdacityAccountError.LastName )
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
                    completionHandlerForAuth(false, UdacityAccountError.ParseAccount)
                    return
                }
                // assign and store unique key for client student
                self.uniqueKey = uniqueKey
                
                guard let sessionInfo = parsedResult[UResponseConstant.Session] as? [String: AnyObject],
                    let sessionId = sessionInfo[UResponseConstant.Id] as? String else {
                        completionHandlerForAuth(false, UdacityAccountError.ParseSession)
                        return
                }
                
                if (registered){
                    // assign sessionId
                    self.sessionId = sessionId
                    completionHandlerForAuth(true, nil)
                }
                else {
                    completionHandlerForAuth(false, UdacityAccountError.Unregistered)
                    return
                }
                
            }
        }
        
    }

}
