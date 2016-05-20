/*
 
 * AMERICA ONLINE CONFIDENTIAL INFORMATION
 
 *
 
 * Copyright (c) 2016 AOL Inc
 
 *
 
 * All Rights Reserved.  Unauthorized reproduction, transmission, or
 
 * distribution of this software is a violation of applicable laws.
 
 */

import Mantle

final class CardModel: MTLModel {
    
    //MARK: Internal Properties
    var email = ""
    var guid = ""
    var id = ""
    var lastFourDigits = ""
    var paymentType = ""
}

extension CardModel: MTLJSONSerializing {
    
    class func JSONKeyPathsByPropertyKey() -> [NSObject: AnyObject] {
        return [
            "email": "email",
            "guid": "guid",
            "id": "id",
            "lastFourDigits": "lastFourDigits",
            "paymentType": "paymentType"
        ]
    }
}
