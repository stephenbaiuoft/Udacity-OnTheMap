//
//  UdacityClientConstant.swift
//  OnTheMap
//
//  Created by stephen on 8/24/17.
//  Copyright © 2017 Bai Cloud Tech Co. All rights reserved.
//

import Foundation

extension Client{
    
    struct UResponseConstant{
        static let Account = "account"
        static let Registered = "registered"
        static let Key = "key"
        
        static let Session = "session"
        static let Id = "id"
    }
    
    struct ULoginConstant{
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
    }
    
    struct UdacityMethod{
        static let UdacitySession = "https://www.udacity.com/api/session"
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
    }
}
