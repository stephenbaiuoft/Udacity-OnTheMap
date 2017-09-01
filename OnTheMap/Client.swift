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
    
    var existed: Bool = false
    var studentInformationSet: [StudentInformation]? = nil
    var currentStuInformation: StudentInformation? = nil
    // the searched place annotation info
    var searchedAnnotation: MKAnnotation?
    
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
}
    
