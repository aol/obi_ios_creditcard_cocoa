/*
 
 * AMERICA ONLINE CONFIDENTIAL INFORMATION
 
 *
 
 * Copyright (c) 2016 AOL Inc
 
 *
 
 * All Rights Reserved.  Unauthorized reproduction, transmission, or
 
 * distribution of this software is a violation of applicable laws.
 
 */

import Foundation

private let letters = "abcdef0123456789"
private let blocksCount = [8, 4, 4, 4, 12]

final class OrderUUIDGenerator {
    
    //MARK: Internal Methods
    static func generate() -> String {
        var blocks = [String]()
        for blockCount in blocksCount {
            let block = randomStringWithLength(blockCount)
            blocks.append(block)
        }
        return blocks.joinWithSeparator("-")
    }
}

private extension OrderUUIDGenerator {
    
    static func randomStringWithLength (len : Int) -> String {
        var result = ""
        for _ in 0..<len {
            let length = UInt32 (letters.characters.count)
            let rand = arc4random_uniform(length)
            let newCharacter = letters[letters.startIndex.advancedBy(Int(rand))]
            result.append(newCharacter)
        }
        
        return result
    }
}
