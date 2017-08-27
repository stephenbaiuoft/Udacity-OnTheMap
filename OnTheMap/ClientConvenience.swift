//
//  ClientConvenience.swift
//  OnTheMap
//
//  Created by stephen on 8/25/17.
//  Copyright © 2017 Bai Cloud Tech Co. All rights reserved.
//

import Foundation

// More Advanced Model Functions that build on Client
extension Client{
    
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
