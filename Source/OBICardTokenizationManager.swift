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
    
    public class func tokenizePaymentMethod(cardIdNumber: String,
                                            cvv: String,
                                            requestToken: String,
                                            authToken: String,
                                            guid: String,
                                            sg: String,
                                            completionBlock: (String?, NSError?) -> Void) {
        let key = requestToken.stringByReplacingOccurrencesOfString("-", withString: "")
        let encryptedString = EncryptionManager.sharedManager.encryptCard(cardIdNumber, cvv: cvv, usingKey: key)
        NetworkManager.sharedManager.tokenizePaymentMethod(authToken,
                                                           guid: guid,
                                                           encryptedString: encryptedString,
                                                           sg: sg)
        { (cardToken, error) in
            if let token = cardToken {
                if !token.token.isEmpty {
                    completionBlock(token.token, nil)
                } else {
                    completionBlock(nil, errorFromString(token.error))
                }
            } else {
                completionBlock(nil, error ?? errorFromString(nil))
            }
        }
    }
}
 
private extension OBICardTokenizationManager {
    
    class func errorFromString(errorString: String?) -> NSError {
        return NSError(domain: kOBICardTokenizationErrorDomain,
            code: 1,
            userInfo: [NSLocalizedDescriptionKey: errorString ?? unknownErrorDescription])
    }
}
