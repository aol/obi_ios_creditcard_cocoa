/*
 
 * AMERICA ONLINE CONFIDENTIAL INFORMATION
 
 *
 
 * Copyright (c) 2016 AOL Inc
 
 *
 
 * All Rights Reserved.  Unauthorized reproduction, transmission, or
 
 * distribution of this software is a violation of applicable laws.
 
 */


import Foundation

enum CardSystem: String {
    case unknown = ""
    
    case visa = "VISA"
    case masterCard = "MASTER_CARD"
    case maestro = "MAESTRO"
    case discover = "DISCOVER"
    case americanExpress = "AMEX"
    case mir = "MIR"
    case unionPay = "UNION_PAY"
    case jcb = "JCB"
    case dinersClub = "DINERS_CLUB"
    
    init(cardNumber: String) {
        if !cardNumber.isEmpty {
            for cardSystem in CardSystem.allTypes() {
                for range in cardSystem.numberRanges() {
                    if CardSystem.numberBelongRange(number: cardNumber, range: range) {
                        self = cardSystem
                        return
                    }
                }
            }
        }
        
        self = .unknown
    }
}

fileprivate extension CardSystem {
    
    static func allTypes() -> [CardSystem] {
        return [.visa, .masterCard, .discover, .americanExpress, .mir, .unionPay, .jcb, .dinersClub, .maestro]
    }
    
    func numberRanges() -> [[String]] {
        switch self {
        case .visa:
            return [["4"]]
        case .masterCard:
            return [["51", "55"], ["2221", "2720"]]
        case .maestro:
            return [["50"], ["56", "58"], ["6"]]
        case .discover:
            return [["6011"], ["622126", "622925"], ["644", "649"], ["65"]]
        case .americanExpress:
            return [["34"],["37"]]
        case .mir:
            return [["2200", "2204"]]
        case .unionPay:
            return [["62"]]
        case .jcb:
            return [["3528", "3589"]]
        case .dinersClub:
            return [["300", "305"], ["309"], ["36"], ["38", "39"]]
            
        case .unknown:
            return [[String]]()
        }
    }
    
    static func numberBelongRange(number: String, range: [String]) -> Bool {
        if range.count == 1 {
            return number.hasPrefix(range.first!)
        } else if range.count == 2 {
            return number >= range.first! && number <= range.last! || number.hasPrefix(range.first!) || number.hasPrefix(range.last!)
        } else {
            return false
        }
    }
}
