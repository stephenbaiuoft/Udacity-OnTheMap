//
//  MapPin.swift
//  OnTheMap
//
//  Created by stephen on 8/26/17.
//  Copyright © 2017 Bai Cloud Tech Co. All rights reserved.
//

import Foundation

struct MapPin{
    
    let firstName: String
    let lastName: String
    let latitude: Float
    let longtitude: Float
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    
    // initializes content for MapPin
    init(studentLocation: [String: AnyObject]) {
        firstName = studentLocation[MapPin.PinConstant.FirstName] as? String ?? ""
        lastName = studentLocation[MapPin.PinConstant.LastName] as? String ?? ""
        latitude = studentLocation[MapPin.PinConstant.Latitude] as? Float ?? 0.0
        longtitude = studentLocation[MapPin.PinConstant.Longitude] as? Float ?? 0.0
        mapString = studentLocation[MapPin.PinConstant.MapString] as? String ?? ""

        mediaURL = studentLocation[MapPin.PinConstant.MediaURL] as? String ?? ""
        objectId = studentLocation[MapPin.PinConstant.ObjectId] as? String ?? ""
        uniqueKey = studentLocation[MapPin.PinConstant.UniqueKey] as? String ?? ""
        
    }
    
    static func locationsFromResults( results: [[String: AnyObject]]) -> [MapPin]{
        var locations = [MapPin]()
        
        for result in results {
            locations.append(MapPin(studentLocation: result))
        }
        
        return locations
    }
}
