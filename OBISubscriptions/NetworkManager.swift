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

final class NetworkManager {
    
    //MARK: Internal Properties
    static let sharedManager = NetworkManager()
    
    //MARK: Private Properties
    private var getSessionManager = AFHTTPSessionManager(baseURL: NSURL(string: NetworkConfig.baseURLString)!)
    
    //MARK: Internal Methods
    func creditCardsForEmail(email: String, completionBlock: ([CardModel]?, NSError?) -> Void) {
        
        let parameters: [String: AnyObject] = [
            "email": email,
        ]
        
        getSessionManager.GET("listInstrument",
            parameters: parameters,
            progress: nil,
            success: { (sessionDataTask, resultObject) in
                if let array = resultObject as? [[NSObject: AnyObject]] {
                    if let result = try? MTLJSONAdapter.modelsOfClass(CardModel.self, fromJSONArray: array) {
                        completionBlock(result as? [CardModel], nil)
                        return
                    }
                }
                completionBlock(nil, nil)
        }) { (sessionDataTask, error) in
            completionBlock(nil, error)
        }
    }
    
    func subscriptionsForEmail(email: String, completionBlock: ([SubscriptionModel]?, NSError?) -> Void) {
        
        let parameters: [String: AnyObject] = [
            "email": email,
            ]
        
        getSessionManager.GET("listSub",
            parameters: parameters,
            progress: nil,
            success: { (sessionDataTask, resultObject) in
                if let array = resultObject as? [[NSObject: AnyObject]] {
                    if let result = try? MTLJSONAdapter.modelsOfClass(SubscriptionModel.self, fromJSONArray: array) {
                        completionBlock(result as? [SubscriptionModel], nil)
                        return
                    }
                }
                completionBlock(nil, nil)
        }) { (sessionDataTask, error) in
            completionBlock(nil, error)
        }
    }
    
    func getRequestToken(email: String, completionBlock: (RequestTokenModel?, NSError?) -> Void) {
        let parameters: [String: AnyObject] = [
            "email": email,
            ]
        
        getSessionManager.GET("getRequestToken",
            parameters: parameters,
            progress: nil,
            success: { (sessionDataTask, resultObject) in
                if let dict = resultObject as? [NSObject: AnyObject] {
                    if let result = try? MTLJSONAdapter.modelOfClass(RequestTokenModel.self, fromJSONDictionary: dict) {
                        completionBlock(result as? RequestTokenModel, nil)
                        return
                    }
                }
                completionBlock(nil, nil)
        }) { (sessionDataTask, error) in
            completionBlock(nil, error)
        }
    }
    
    func tokenizePaymentMethod(authToken: String, guid: String, encryptedString: String, completionBlock: (CardTokenModel?, NSError?) -> Void) {
        let urlString = NetworkConfig.tokenizePaymentMethodURLString + "?" +
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
    
    func setupPaymentMethod(email: String, token: String, userData: UserData, completionBlock: (PaymentMethodModel?, NSError?) -> Void) {
        let range = userData.idNumber.startIndex..<userData.idNumber.startIndex.advancedBy(1)
        let symbol = userData.idNumber.substringWithRange(range)
        let paymentType = CardSystem(systemDigit: Int(symbol)!)
            
            var month = userData.month
            if month.characters.count == 1 {
                month = "0" + month
            }
            var year = userData.year
            if year.characters.count == 2 {
                year = "20" + year
            }
            
            let url = NSURL(string: NetworkConfig.setupPaymentMethodURLString)
            let request = NSMutableURLRequest(URL: url!)
            request.HTTPMethod = "POST"
            
            let jsonDict = [
                "email": email,
                "firstName": userData.firstName,
                "lastName": userData.lastName,
                "street1": userData.address,
                "city": userData.city,
                "state": userData.state,
                "zip": userData.zip,
                "country": "US",
                "accountNumber": token,
                "expiryDate": month + year,
                "paymentType": paymentType.title()
            ]
            
            let bodyData = try? NSJSONSerialization.dataWithJSONObject(jsonDict, options: [])
            request.HTTPBody = bodyData
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let sessionManager = AFHTTPSessionManager()
            let task = sessionManager.dataTaskWithRequest(request) { (response, responseObject, error) in
                let dict = responseObject as? [NSObject: AnyObject]
                if let result = try? MTLJSONAdapter.modelOfClass(PaymentMethodModel.self, fromJSONDictionary: dict) {
                    completionBlock(result as? PaymentMethodModel, nil)
                    return
                }
                completionBlock(nil, error)
            }
            task.resume()
    }
    
    func subscribe(email: String, pmId: String, price: String, completionBlock: (SubscriptionModel?, NSError?) -> Void) {
        let url = NSURL(string: NetworkConfig.subscribeURLString)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        
        let jsonDict = [
            "email": email,
            "pmId": pmId,
            "source": "testobi-2",
            "salePrice": price,
            "orderUUID": OrderUUIDGenerator.generate()
        ]
        
        let bodyData = try? NSJSONSerialization.dataWithJSONObject(jsonDict, options: [])
        request.HTTPBody = bodyData
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json, text/plain, */*", forHTTPHeaderField: "Accept")

        let sessionManager = AFHTTPSessionManager()
        let task = sessionManager.dataTaskWithRequest(request) { (response, responseObject, error) in
            let dict = responseObject as? [NSObject: AnyObject]
            if let result = try? MTLJSONAdapter.modelOfClass(SubscriptionModel.self, fromJSONDictionary: dict) {
                completionBlock(result as? SubscriptionModel, nil)
                return
            }

            completionBlock(nil, error)
        }
        task.resume()
    }
}
