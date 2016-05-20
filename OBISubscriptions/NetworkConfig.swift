/*
 
 * AMERICA ONLINE CONFIDENTIAL INFORMATION
 
 *
 
 * Copyright (c) 2016 AOL Inc
 
 *
 
 * All Rights Reserved.  Unauthorized reproduction, transmission, or
 
 * distribution of this software is a violation of applicable laws.
 
 */

struct NetworkConfig {
    
    static let baseURLString = "http://demoapp.qat.obi.aol.com"
    
    static let setupPaymentMethodURLString = baseURLString +  "/" + "setupPaymentMethod"
    static let subscribeURLString = baseURLString +  "/" + "subscribe"
    
    static let tokenizePaymentMethodURLString = "https://jsl.qat.obi.aol.com/obipmservice/apiCall"
}
