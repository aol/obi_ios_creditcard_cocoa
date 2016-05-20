/*
 
 * AMERICA ONLINE CONFIDENTIAL INFORMATION
 
 *
 
 * Copyright (c) 2016 AOL Inc
 
 *
 
 * All Rights Reserved.  Unauthorized reproduction, transmission, or
 
 * distribution of this software is a violation of applicable laws.
 
 */

enum CardSystem: Int {
    case Unknown = 0
    case AmericanExpress = 3
    case Visa = 4
    case MasterCard = 5
    case Maestro = 6
    
    init(systemDigit: Int) {
        if let cardSystem = CardSystem(rawValue: systemDigit) {
            self = cardSystem
        } else {
            self = .Unknown
        }
    }
    
    func title() -> String {
        switch self {
        case AmericanExpress:
            return "American Express"
        case Visa:
            return "VISA"
        case MasterCard:
            return "MasterCard"
        case Maestro:
            return "Maestro"
            
        default:
            return ""
        }
    }
}
