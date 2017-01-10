/*
 
 * AMERICA ONLINE CONFIDENTIAL INFORMATION
 
 *
 
 * Copyright (c) 2016 AOL Inc
 
 *
 
 * All Rights Reserved.  Unauthorized reproduction, transmission, or
 
 * distribution of this software is a violation of applicable laws.
 
 */

import Foundation

//OBICardTokenization


public let kOBICardTokenizationErrorDomain = "kOBICardTokenizationErrorDomain"

private let unknownErrorDescription = "Unknown error"

final public class OBICardTokenizationManager {
    
    /**
     Tokenize credit/debit card data with results of "getRequestToken" action
     
     - parameter cardNumber: card's id number
     - parameter cvv: card's cvv code
     - parameter requestToken: request token - result of "getRequestToken" action
     - parameter authToken: authorization token - result of "getRequestToken" action
     - parameter guid: user id
     - parameter sg: client id
     - parameter completionBlock: result block. This block provide result of tokenizatoin or error
     */
    public class func tokenizePaymentMethod(cardNumber: String,
                                            cvv: String,
                                            requestToken: String,
                                            authToken: String,
                                            guid: String,
                                            sg: String,
                                            completionBlock: @escaping (String?, NSError?) -> Void) {
        let key = requestToken.replacingOccurrences(of: "-", with: "")
        let encrypted = EncryptionManager.sharedManager.encryptCard(cardNumber, cvv: cvv, usingKey: key)
        NetworkManager.shared.tokenize(authToken:authToken, guid: guid, encrypted: encrypted, sg: sg) { (cardToken, error) in
            if let token = cardToken, !token.isEmpty {
                completionBlock(token, nil)
            } else {
                completionBlock(nil, error ?? errorFromString(nil))
            }
        }
    }
}
 
private extension OBICardTokenizationManager {
    
    class func errorFromString(_ errorString: String?) -> NSError {
        return NSError(domain: kOBICardTokenizationErrorDomain,
            code: 1,
            userInfo: [NSLocalizedDescriptionKey: errorString ?? unknownErrorDescription])
    }
}
