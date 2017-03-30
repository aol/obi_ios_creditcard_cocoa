/*
 
 * AMERICA ONLINE CONFIDENTIAL INFORMATION
 
 *  
 
 * Copyright (c) 2016 AOL Inc

 *

 * All Rights Reserved.  Unauthorized reproduction, transmission, or
 
 * distribution of this software is a violation of applicable laws.
    
 */ 
//  BaseUrlType.swift
//  OBICardTokenization

import Foundation


public enum BaseUrlType: String {
    case DEV = "https://jsl.dev.obi.aol.com/obipmservice/apiCall"
    case PROD = "https://jsl.prod.obi.aol.com/obipmservice/apiCall"
    case QA = "https://jsl.qat.obi.aol.com/obipmservice/apiCall"
}
