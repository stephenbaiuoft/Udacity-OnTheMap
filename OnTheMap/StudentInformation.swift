///Users/stephen/Desktop/Udacity iOS/Udacity Git Projects Submit/OnTheMap/OnTheMap/StudentInformation.swift
//  StudentInformation.swift
//  OnTheMap
//
//  Created by stephen on 9/1/17.
//  Copyright © 2017 Bai Cloud Tech Co. All rights reserved.
//

import Foundation
import MapKit

struct StudentInformation{
    
    let firstName: String
    let lastName: String
    var latitude: Double
    var longtitude: Double
    var mapString: String
    var mediaURL: String
    let objectId: String
    let uniqueKey: String
    var annotation: MKPointAnnotation
    
    // initializes content for PARSE array of studentLocationInformation JSONs
    init(studentLocation: [String: AnyObject]) {
        firstName = studentLocation[StuInfoConstant.FirstName] as? String ?? ""
        lastName = studentLocation[StuInfoConstant.LastName] as? String ?? ""
        latitude = studentLocation[StuInfoConstant.Latitude] as? Double ?? 0.0
        longtitude = studentLocation[StuInfoConstant.Longitude] as? Double ?? 0.0
        mapString = studentLocation[StuInfoConstant.MapString] as? String ?? ""
        
        mediaURL = studentLocation[StuInfoConstant.MediaURL] as? String ?? ""
        objectId = studentLocation[StuInfoConstant.ObjectId] as? String ?? ""
        uniqueKey = studentLocation[StuInfoConstant.UniqueKey] as? String ?? ""
        
        annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
        annotation.title = "\(firstName) \(lastName)"
        annotation.subtitle = mediaURL
        
    }
    
    static func infoFromResults( results: [[String: AnyObject]]) -> [StudentInformation]{
        var locations = [StudentInformation]()
        
        for result in results {
            locations.append(StudentInformation(studentLocation: result))
        }
        
        return locations
    }
}


extension StudentInformation{
    
    struct StuInfoConstant{
        static let ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "lastName"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
    }
}
