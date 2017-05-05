/*
 
 * AMERICA ONLINE CONFIDENTIAL INFORMATION
 
 *
 
 * Copyright (c) 2016 AOL Inc
 
 *
 
 * All Rights Reserved.  Unauthorized reproduction, transmission, or
 
 * distribution of this software is a violation of applicable laws.
 
 */

import Foundation

public let kOBICardTokenizationErrorDomain = "kOBICardTokenizationErrorDomain"

private let unknownErrorDescription = "Unknown error"

final public class OBICardTokenizationManager {
    
    public static var urlString = ""

    /**
     Tokenize credit/debit card data with uuid
     
     - parameter cardNumber: card's id number
     - parameter cvv: card's cvv code
     - parameter domain: tokenizatoin domain
     - parameter completionBlock: result block. This block provide result of tokenizatoin or error
     */
    public class func tokenizeCard(cardNumber: String, cvv: String, domain: BaseUrlType, completionBlock: @escaping (String?, NSError?) -> Void) {
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
    
    /**
     Tokenize bank account number with uuid
     
     - parameter accountNumber: bank account number
     - parameter domain: tokenizatoin domain
     - parameter completionBlock: result block. This block provide result of tokenizatoin or error
     */
    public class func tokenizeBankAccount(accountNumber: String, domain: BaseUrlType,completionBlock: @escaping (String?, NSError?) -> Void) {
        let uuid = UUID().uuidString
        let key = removeUnwantedChars(str: uuid)
        let encrypted = EncryptionManager.sharedManager.encryptBankAccount(accountNumber: accountNumber, usingKey: key)
        NetworkManager.shared.tokenize(encrypted: encrypted, domain: domain.rawValue) { (cardToken, error) in
            if let token = cardToken, !token.isEmpty {
                completionBlock(token + ";" + key, nil)
            } else {
                completionBlock(nil, error ?? errorFromString(nil))
            }
        }
    }
}
 
private extension OBICardTokenizationManager {
    
    class func removeUnwantedChars(str: String)-> String{
        let value = str.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: " ", with: "")
        return value
    }
    
    class func errorFromString(_ errorString: String?) -> NSError {
        return NSError(domain: kOBICardTokenizationErrorDomain,
            code: 1,
            userInfo: [NSLocalizedDescriptionKey: errorString ?? unknownErrorDescription])
    }
}
