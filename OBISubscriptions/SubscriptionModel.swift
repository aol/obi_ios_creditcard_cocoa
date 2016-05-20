/*
 
 * AMERICA ONLINE CONFIDENTIAL INFORMATION
 
 *
 
 * Copyright (c) 2016 AOL Inc
 
 *
 
 * All Rights Reserved.  Unauthorized reproduction, transmission, or
 
 * distribution of this software is a violation of applicable laws.
 
 */

import Mantle

final class SubscriptionModel: MTLModel {
    
    //MARK: Internal Properties
    var email = ""
    var guid = ""
    var offerId = ""
    var productId = ""
    var orderId = ""
    var offerName = ""
    var salePrice = ""
    var purchaseDt = ""
}

extension SubscriptionModel: MTLJSONSerializing {
    
    class func JSONKeyPathsByPropertyKey() -> [NSObject: AnyObject] {
        return [
            "email": "email",
            "guid": "guid",
            "offerId": "offerId",
            "productId": "productId",
            "orderId": "orderId",
            "offerName": "offerName",
            "salePrice": "salePrice",
            "purchaseDt": "purchaseDt"
        ]
    }
}
