/*
 
 * AMERICA ONLINE CONFIDENTIAL INFORMATION
 
 *
 
 * Copyright (c) 2016 AOL Inc
 
 *
 
 * All Rights Reserved.  Unauthorized reproduction, transmission, or
 
 * distribution of this software is a violation of applicable laws.
 
 */

import Mantle

final class RequestTokenModel: MTLModel {
    
    //MARK: Internal Properties
    var guid = ""
    var authToken = ""
    var reqToken = ""
}

extension RequestTokenModel: MTLJSONSerializing {
    
    class func JSONKeyPathsByPropertyKey() -> [NSObject: AnyObject] {
        return [
            "guid": "guid",
            "authToken": "authToken",
            "reqToken": "reqToken",
        ]
    }
}
