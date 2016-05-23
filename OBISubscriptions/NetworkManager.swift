/*
 
 * AMERICA ONLINE CONFIDENTIAL INFORMATION
 
 *
 
 * Copyright (c) 2016 AOL Inc
 
 *
 
 * All Rights Reserved.  Unauthorized reproduction, transmission, or
 
 * distribution of this software is a violation of applicable laws.
 
 */

import Foundation
import AFNetworking
import Mantle

private let tokenizePaymentMethodURLString = "https://jsl.qat.obi.aol.com/obipmservice/apiCall"

final class NetworkManager {
    
    //MARK: Internal Properties
    static let sharedManager = NetworkManager()
    
    //MARK: Internal Methods
    func tokenizePaymentMethod(authToken: String, guid: String, encryptedString: String, completionBlock: (CardTokenModel?, NSError?) -> Void) {
        let urlString = tokenizePaymentMethodURLString + "?" +
            "apiName=tokenizePaymentMethod&sg=testobi&t=\(authToken)&tg=\(guid)&country=US&lang=en"
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        
        let requestData = ["requestData": encryptedString]
        let jsonDict = ["tokenizePaymentMethod": requestData]
        let bodyData = try? NSJSONSerialization.dataWithJSONObject(jsonDict, options: [])
        request.HTTPBody = bodyData
        
        let sessionManager = AFHTTPSessionManager()
        sessionManager.responseSerializer = AFHTTPResponseSerializer()
        let task = sessionManager.dataTaskWithRequest(request) { (response, responseObject, error) in
            let data = responseObject as! NSData
            let json = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
            let dict = json as? [NSObject: AnyObject]
            if let result = try? MTLJSONAdapter.modelOfClass(CardTokenModel.self, fromJSONDictionary: dict) {
                completionBlock(result as? CardTokenModel, nil)
                return
            }
            completionBlock(nil, error)
        }
        task.resume()        
    }
}
