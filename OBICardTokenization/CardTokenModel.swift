/*
 
 * AMERICA ONLINE CONFIDENTIAL INFORMATION
 
 *
 
 * Copyright (c) 2016 AOL Inc
 
 *
 
 * All Rights Reserved.  Unauthorized reproduction, transmission, or
 
 * distribution of this software is a violation of applicable laws.
 
 */

import Mantle

final class CardTokenModel: MTLModel {
    
    //MARK: Internal Properties
    var statusCode = ""
    var statusText = ""
    var requestId = ""
    var token = ""
    var error = ""
}

extension CardTokenModel: MTLJSONSerializing {
    
    class func JSONKeyPathsByPropertyKey() -> [NSObject: AnyObject] {
        return [
            "statusCode": "statusCode",
            "statusText": "statusText",
            "requestId": "requestId",
            "token": "data.m:tokenizePaymentMethodResponse.m:result",
            "error": "data.messages.message.text",
        ]
    }
}
