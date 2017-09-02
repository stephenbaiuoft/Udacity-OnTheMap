//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by stephen on 8/24/17.
//  Copyright © 2017 Bai Cloud Tech Co. All rights reserved.
//

import Foundation
import MapKit

// This file is base varialbe declarations 
class Client: NSObject{
    
    // PARSE Response: shared session
    var session = URLSession.shared
    var sessionId: String? = nil
    var uniqueKey: String?
    var firstName: String?
    var lastName: String?
    var objectId: String?
    
    // record if location has been submitted previously: False Initially
    var postedLocation: Bool = false
    
    var studentInformationSet: [StudentInformation]? = nil
    
    // Before submitting/posting/putting information
    // the searched place annotation info ==> Save trouble of using Segue Data Passing
    var searchedPlaceMark: MKPlacemark?
    var addedWebUrl: String?
    var mapLocationString: String?
    
    // MARK: Shared Instance
    class func sharedInstance()-> Client{
        struct Singleton{
            static var sharedInstance = Client()
        }
        return Singleton.sharedInstance
    }
    
    // privately logging tool for debugging on console
    func log(_ msg: String, _ item: AnyObject?){
        if(true) {
            print("log: ", msg, item ?? "")
        }
    }
    
    func log(_ msg: String) {
        if(true) {
            print("log: ", msg)
        }
    }
}
    
