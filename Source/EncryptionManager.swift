/*
 
 * AMERICA ONLINE CONFIDENTIAL INFORMATION
 
 *
 
 * Copyright (c) 2016 AOL Inc
 
 *
 
 * All Rights Reserved.  Unauthorized reproduction, transmission, or
 
 * distribution of this software is a violation of applicable laws.
 
 */

import Foundation

final class EncryptionManager {
    
    //MARK: Internal properties
    static let sharedManager = EncryptionManager()
    
    //MARK: Internal Methods
    func encryptCard(cardNumber: String, cvv: String, usingKey: String) -> String {
        let stringToEnctypt = cardNumber + ";" + cvv
        
        let data = stringToEnctypt.dataUsingEncoding(NSUTF8StringEncoding)?.mutableCopy() as! NSMutableData
        let count = 16 - data.length % 16
        let emptyBytes: [UInt8] = Array(count: count, repeatedValue: 0)
        data.appendBytes(emptyBytes, length: count)
        
        if let encryptedData = data.AES128EncryptWithKey(usingKey) {
            return encryptedData.base64EncodedStringWithOptions([])
        } else {
            return ""
        }
    }
}
