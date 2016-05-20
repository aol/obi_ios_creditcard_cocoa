/*
 
 * AMERICA ONLINE CONFIDENTIAL INFORMATION
 
 *
 
 * Copyright (c) 2016 AOL Inc
 
 *
 
 * All Rights Reserved.  Unauthorized reproduction, transmission, or
 
 * distribution of this software is a violation of applicable laws.
 
 */

import Mantle

final class PaymentMethodModel: MTLModel {
    
    //MARK: Internal Properties
    var pmId = ""
    var errorMsg = ""
}

extension PaymentMethodModel: MTLJSONSerializing {
    
    class func JSONKeyPathsByPropertyKey() -> [NSObject: AnyObject] {
        return [
            "pmId": "pmId",
            "errorMsg": "errorMsg"
        ]
    }
}
