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
    
    public static var urlString = ""

    /**
     Tokenize credit/debit card data with results of "getRequestToken" action
     
     - parameter cardNumber: card's id number
     - parameter cvv: card's cvv code
     - parameter completionBlock: result block. This block provide result of tokenizatoin or error
     */
    public class func tokenizePaymentMethod(cardNumber: String,cvv: String,domain: BaseUrlType,completionBlock: @escaping (String?, NSError?) -> Void) {
        let uuid = UUID().uuidString
        let key = removeUnwantedChars(str: uuid)
        let cardNum = removeUnwantedChars(str: cardNumber)
        let encrypted = EncryptionManager.sharedManager.encryptCard(cardNumber: cardNum, cvv: cvv, usingKey: key)
        NetworkManager.shared.tokenize(encrypted: encrypted, domain: domain.rawValue) { (cardToken, error) in
            if let token = cardToken, !token.isEmpty {
                completionBlock(token + ";" + key, nil)
            } else {
                completionBlock(nil, error ?? errorFromString(nil))
            }
        }
    }
    public class func removeUnwantedChars(str: String)-> String{
        let value = str.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: " ", with: "")
        return value
    }
}
 
private extension OBICardTokenizationManager {
    
    class func errorFromString(_ errorString: String?) -> NSError {
        return NSError(domain: kOBICardTokenizationErrorDomain,
            code: 1,
            userInfo: [NSLocalizedDescriptionKey: errorString ?? unknownErrorDescription])
    }
}
