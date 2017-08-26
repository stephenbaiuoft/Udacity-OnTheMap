//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by stephen on 8/24/17.
//  Copyright © 2017 Bai Cloud Tech Co. All rights reserved.
//

import Foundation

// More Basic Functions
class Client: NSObject{
    
    // shared session
    var session = URLSession.shared
    var sessionId: String? = nil
        
    
    // MARK: method to post to any web Server
    func taskForPostMethod(method: String, parameters:[String: String], jsonBodyData: Data, completionHandlerForPostToU: @escaping (_ result: AnyObject?, _ error: NSError?)->Void) -> URLSessionDataTask{
        
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
            
            self.convertDataWithCompletionHandler(data: data, completionHandlerForConvertData: completionHandlerForPostToU)
            
        }
        task.resume()
        // return task for debugging issues
        return task
    }
    
    // given raw JSON, return a usable Foundation object
    // No need to escape completionHandlerForConvertData as it is not used outside completionHandlerForConvertData!!!!
    private func convertDataWithCompletionHandler(data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?)->Void) {
        let range = Range(5..<data.count)
        let newData = data.subdata(in: range)
        
        let parsedResult: AnyObject!
        do{
            parsedResult = try JSONSerialization.jsonObject(with: newData, options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject
            
            print("debug: parsedJSON Result:", parsedResult)
            
            completionHandlerForConvertData(parsedResult, nil)
        } catch {
            completionHandlerForConvertData(nil, NSError.init(domain: "convertDataWithCompletionHandler", code: 1, userInfo: [NSLocalizedDescriptionKey:"Failed to convert"]) )
            return
        }
    }
    
    
    // MARK: Shared Instance
    class func sharedInstance()-> Client{
        struct Singleton{
            static var sharedInstance = Client()
        }
        return Singleton.sharedInstance
    }
}
    
