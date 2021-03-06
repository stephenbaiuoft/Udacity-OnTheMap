//
//  ClientUrlTaskMethods.swift
//  OnTheMap
//
//  Created by stephen on 8/31/17.
//  Copyright © 2017 Bai Cloud Tech Co. All rights reserved.
//

import Foundation
import UIKit

// This file contains helper taskFor <URL> basic methods
extension Client {
    
    func taskForDeleteSession(completionHandlerForDelete: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var request = URLRequest.init(url: URL.init(string: UdacityMethod.UdacitySession)!)
        request.httpMethod = "DELETE"
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = Client.sharedInstance().session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForDelete(nil , NSError(domain: "taskForDeleteSession", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                sendError("No data was return from your request")
                return
            }
            
            // Do not chopData for getting mapLocation Info
            self.convertDataWithCompletionHandler(true, data: data, completionHandlerForConvertData: completionHandlerForDelete)
            
        })
        
        task.resume()
    }
    
    
    // MARK: method to post student location to PARSE Server
    func taskForModifyLocation(requestMethod: String ,method: String, jsonBodyData: Data, completionHandlerForGetLocation: @escaping (_ result: AnyObject?, _ error: NSError?)->Void ) -> URLSessionDataTask{
        
        var request = URLRequest.init(url: URL.init(string: method)!)
        
        request.httpMethod = requestMethod
        request.addValue(ParseConstantValue.ParseApplicationId, forHTTPHeaderField: ParseConstantKey.ParseApplicationId)
        request.addValue(ParseConstantValue.RESTAPIKey, forHTTPHeaderField: ParseConstantKey.RESTAPIKey)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = jsonBodyData
        
        //print("taskForModifyLocation url is:", request.url, "\nwith method of:", requestMethod)
        
        let task = Client.sharedInstance().session.dataTask(with: request) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGetLocation(nil, NSError(domain: "taskForPosttLocation", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                sendError("No data was return from your request")
                return
            }
            
            // Do not chopData for getting mapLocation Info
            self.convertDataWithCompletionHandler(false, data: data, completionHandlerForConvertData: completionHandlerForGetLocation)
            
        }
        
        task.resume()
        return task
    }
    
    
    
    // Mark: method to get student location/locations information
    // parameters: optional in terms of limit, skip, order
    func taskForGetLocation(method: String, parametersUrl: String, completionHandlerForGetLocation: @escaping (_ result: AnyObject?, _ error: NSError?)->Void ) -> URLSessionDataTask{
        
        // Hard-Coded Set for Requirement
        //let parametersUrl = "?limit=100&order=-updatedAt"
        let urlString = method + parametersUrl
        
        var request = URLRequest.init(url: URL.init(string: urlString)!)
        request.addValue(ParseConstantValue.ParseApplicationId, forHTTPHeaderField: ParseConstantKey.ParseApplicationId)
        request.addValue(ParseConstantValue.RESTAPIKey, forHTTPHeaderField: ParseConstantKey.RESTAPIKey)
        log("request url:", request.url as AnyObject)
        
        let task = Client.sharedInstance().session.dataTask(with: request) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGetLocation(nil, NSError(domain: "taskForGetLocation", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            // To be Deleted: Debug
            //print(data)
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                sendError("No data was return from your request")
                return
            }
            
            // Do not chopData for getting mapLocation Info
            self.convertDataWithCompletionHandler(false, data: data, completionHandlerForConvertData: completionHandlerForGetLocation)
            
        }
        
        task.resume()
        return task
    }
    
    // MARK: method to get to any web Server
    func taskForGetMethod(method: String, completionHandlerForPostToU: @escaping (_ result: AnyObject?, _ error: NSError?)->Void) -> URLSessionDataTask {
        let request = URLRequest.init(url: URL.init(string: method)!)
        
        let task = Client.sharedInstance().session.dataTask(with: request) { (data, response, error) in
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPostToU(nil, NSError(domain: "taskForGetMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                sendError("No data was return from your request")
                return
            }
            
            self.convertDataWithCompletionHandler(true, data: data, completionHandlerForConvertData: completionHandlerForPostToU)
            
        }
        
        return task
    }
    
    
    // MARK: method to post to any web Server
    func taskForPostMethod(method: String, jsonBodyData: Data, completionHandlerForPostToU: @escaping (_ result: AnyObject?, _ error: NSError?)->Void) -> URLSessionDataTask{
        
        var request = URLRequest.init(url: URL.init(string: method)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        //Debug if its json???
        request.httpBody = jsonBodyData
        //request.httpBody = "{\"udacity\": {\"username\": \"steinfo11@gmail.com\", \"password\": \"testtest\"}}".data(using: String.Encoding.utf8)
        
        
        let task = Client.sharedInstance().session.dataTask(with: request) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPostToU(nil, NSError(domain: "taskForPostMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError(HttpErrorMsg.SessionError)
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 403 {
                    // 403 meaning it is not correct!
                    sendError(LoginError.AccountError)
                    return
                } else if( statusCode < 200 || statusCode > 299) {
                    // incorrect status code
                    sendError(HttpErrorMsg.StatusCode)
                    return
                }
            }
            
            // meaning statusCode is correct
            guard let data = data else {
                sendError(HttpErrorMsg.DataReturn)
                return
            }
            
            self.convertDataWithCompletionHandler(true, data: data, completionHandlerForConvertData: completionHandlerForPostToU)
            
        }
        task.resume()
        // return task for debugging issues
        return task
    }
    
    // given raw JSON, return a usable Foundation object
    // No need to escape completionHandlerForConvertData as it is not used outside completionHandlerForConvertData!!!!
    private func convertDataWithCompletionHandler(_ chopData: Bool, data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?)->Void) {
        var newData = data
        
        if chopData {
            let range = Range(5..<data.count)
            newData = data.subdata(in: range)
        }
        
        let parsedResult: AnyObject!
        do{
            parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
            
            completionHandlerForConvertData(parsedResult, nil)
        } catch {
            completionHandlerForConvertData(nil, NSError.init(domain: "convertDataWithCompletionHandler", code: 1, userInfo: [NSLocalizedDescriptionKey:"Failed to convert to AnyObject?????"]) )
            return
        }
    }
    
    

}
