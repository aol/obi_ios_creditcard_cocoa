/*
 
 * AMERICA ONLINE CONFIDENTIAL INFORMATION
 
 *
 
 * Copyright (c) 2016 AOL Inc
 
 *
 
 * All Rights Reserved.  Unauthorized reproduction, transmission, or
 
 * distribution of this software is a violation of applicable laws.
 
 */

import Foundation

private let tokenKeyPath = "data.m:tokenizePaymentMethodResponse.m:result"
private let emptyUrlErrorDescription = "Tokenization URL is empty"

final class NetworkManager {
    
    //MARK: Internal Properties
    static let shared = NetworkManager()
    
    //MARK: Internal Methods
    func tokenize(authToken: String, guid: String, encrypted: String, sg: String, completionBlock: @escaping (String?, NSError?) -> Void) {
        if OBICardTokenizationManager.urlString.isEmpty {
            completionBlock(nil, NSError(domain: kOBICardTokenizationErrorDomain, code: 2, userInfo: [NSLocalizedDescriptionKey: emptyUrlErrorDescription]))
        }
        
        let urlString =
            OBICardTokenizationManager.urlString + "?" + "apiName=tokenizePaymentMethod&sg=\(sg)&t=\(authToken)&tg=\(guid)&country=US&lang=en"
        let url = URL(string: urlString)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        
        let requestData = ["requestData": encrypted]
        let jsonDict = ["tokenizePaymentMethod": requestData]
        let bodyData = try? JSONSerialization.data(withJSONObject: jsonDict, options: [])
        request.httpBody = bodyData
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (responseObject, response, error) in
            DispatchQueue.main.async {
                if let data = responseObject {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                        if let dict = json as? [AnyHashable: Any] {
                            if let token = (dict as NSDictionary).value(forKeyPath: tokenKeyPath) as? String {
                                completionBlock(token, nil)
                                return
                            }
                        }
                    }
                    completionBlock(nil, nil)
                } else if let e = error {
                    completionBlock(nil, e as NSError)
                }
            }
        }
        task.resume()
    }
}
