//
//  UdacityClientConstant.swift
//  OnTheMap
//
//  Created by stephen on 8/24/17.
//  Copyright © 2017 Bai Cloud Tech Co. All rights reserved.
//

import Foundation

extension Client{
    
    struct WebUrlError {
        static let OpenUrl = "Failed to open the url: most likely the url is invalid"
    }
    
    // common error in HttpError
    struct HttpErrorMsg{
        static let SessionError = "There was an error with your request: "
        static let StatusCode = "Your request returned a status code other than 2xx!"
        static let DataReturn = "No data was return from your request"
    }
    
    // common error in Converting Data
    struct JSONConversionError{
        static let JSONToDicAry = "Failed to convert JSON to [[String: AnyObject]]"
    }
    
    struct UdacityAccountError{
        static let ParseAccount = "Failed to parse user account info"
        static let ParseSession = "Failed to parse user session info"
        static let Unregistered = "User not registered on Udacity"
        static let UserInfo = "Failed to get userInfo"
        static let LastName = "Failed to get lastName"
    }
    
    struct NotificationConstant{
        static let MapPinAdded = "mapPinAdded"
    }
    
    struct SegueIdentifierConstant{
        static let gotoAddLocationIdentifier = "addLocationIdentifier"
    }
    
    struct UResponseConstant{
        static let Account = "account"
        static let Registered = "registered"
        static let Key = "key"
        
        static let Session = "session"
        static let Id = "id"
        static let User = "user"
        static let Guard = "guard"
        static let firstName = "first_name"
        static let lastName = "last_name"
    }
    
    struct ULoginConstant{
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
    }
    
    struct UdacityMethod{
        static let UdacitySession = "https://www.udacity.com/api/session"
        static let UdacityUserData = "https://www.udacity.com/api/users/"
    }

    
    struct ParseConstantKey{
        static let ParseApplicationId = "X-Parse-Application-Id"
        static let RESTAPIKey = "X-Parse-REST-API-Key"
    }
    
    struct ParseConstantValue{
        static let ParseApplicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RESTAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    struct ParseResponseKeys{
        static let Results = "results"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
    }
    
    struct ParseMethod{
        static let GetStudentLocation = "https://parse.udacity.com/parse/classes/StudentLocation"
        static let PostStudentLocation = "https://parse.udacity.com/parse/classes/StudentLocation"
    }
}
