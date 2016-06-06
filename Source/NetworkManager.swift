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
        
        let requestData = ["requestData": encryptedString]
        let jsonDict = [
            "tokenizePaymentMethod": requestData,
        ]
        
        let sessionManager = AFHTTPSessionManager(baseURL: NSURL(string: tokenizePaymentMethodURLString)!)
        sessionManager.requestSerializer = AFJSONRequestSerializer()
        sessionManager.responseSerializer = AFHTTPResponseSerializer()
        sessionManager.POST(urlString, parameters: jsonDict, progress: nil, success: { (session, responseObject) in
            if let data = responseObject as? NSData {
                if let json = try? NSJSONSerialization.JSONObjectWithData(data, options: []) {
                    if let dict = json as? [NSObject: AnyObject] {
                        if let result = try? MTLJSONAdapter.modelOfClass(CardTokenModel.self, fromJSONDictionary: dict) {
                            completionBlock(result as? CardTokenModel, nil)
                            return
                        }
                    }
                }
            }
            completionBlock(nil, nil)
        }) { (session, error) in
            completionBlock(nil, error)
        }
    }
}
