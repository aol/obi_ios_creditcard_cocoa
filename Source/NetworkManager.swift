/*
 
 * AMERICA ONLINE CONFIDENTIAL INFORMATION
 
 *
 
 * Copyright (c) 2016 AOL Inc
 
 *
 
 * All Rights Reserved.  Unauthorized reproduction, transmission, or
 
 * distribution of this software is a violation of applicable laws.
 
 */

import Foundation

private let tokenizePaymentMethodURLString = "https://jsl.qat.obi.aol.com/obipmservice/apiCall"
private let tokenKeyPath = "data.m:tokenizePaymentMethodResponse.m:result"

final class NetworkManager {
    
    //MARK: Internal Properties
    static let sharedManager = NetworkManager()
    
    //MARK: Internal Methods
    func tokenizePaymentMethod(authToken: String, guid: String, encryptedString: String, sg: String, completionBlock: (String?, NSError?) -> Void) {
        let urlString = tokenizePaymentMethodURLString + "?" +
            "apiName=tokenizePaymentMethod&sg=\(sg)&t=\(authToken)&tg=\(guid)&country=US&lang=en"
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        
        let requestData = ["requestData": encryptedString]
        let jsonDict = ["tokenizePaymentMethod": requestData]
        let bodyData = try? NSJSONSerialization.dataWithJSONObject(jsonDict, options: [])
        request.HTTPBody = bodyData
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (responseObject, response, error) in
            if let data = responseObject {
                if let json = try? NSJSONSerialization.JSONObjectWithData(data, options: []) {
                    if let dict = json as? [NSObject: AnyObject] {
                        if let token = (dict as NSDictionary).valueForKeyPath(tokenKeyPath) as? String {
                            completionBlock(token, nil)
                            return
                        }
                    }
                }
                completionBlock(nil, nil)
            } else if let e = error {
                completionBlock(nil, e)
            }
        }
        task.resume()
    }
}
