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
    func encryptCard(_ cardNumber: String, cvv: String, usingKey: String) -> String {
        let stringToEnctypt = cardNumber + ";" + cvv
        
        var data = stringToEnctypt.data(using: String.Encoding.utf8)!
        let count = 16 - data.count % 16
        let emptyBytes: [UInt8] = Array(repeating: 0, count: count)
        data.append(emptyBytes, count: count)
        
        if let encryptedData = (data as NSData).aes128Encrypt(withKey32: usingKey) {
            return encryptedData.base64EncodedString(options: [])
        } else {
            return ""
        }
    }
}
