//
//  CLTokenizer.swift
//  Lexel
//
//  Created by enzo on 5/30/24.
//

import Foundation
import CoreFoundation
import CoreFoundation.CFStringTokenizer

let kCFStringTokenizerTokenNone = 0
typealias Token = String

extension String {
    func tokenize(unit: CFOptionFlags) -> [Token] {
        let str = self as CFString
        let tokenizer: CFStringTokenizer = CFStringTokenizerCreate(
            kCFAllocatorDefault,
            str,
            CFRangeMake(0, CFStringGetLength(str)),
            unit,
            CFLocaleCopyCurrent()
        )
        
        var tokens: [Token] = []
        
        var tokenType = CFStringTokenizerAdvanceToNextToken(tokenizer)
        while tokenType.rawValue != 0 {
            let currentTokenRange = CFStringTokenizerGetCurrentTokenRange(tokenizer)
            let substring = self.substringWithRange(currentTokenRange)
            tokens.append(substring)
            tokenType = CFStringTokenizerAdvanceToNextToken(tokenizer)
        }
        
        return tokens
    }
    
    func substringWithRange(_ aRange: CFRange) -> String {
        let nsrange = NSMakeRange(aRange.location, aRange.length)
        let substring = (self as NSString).substring(with: nsrange)
        return substring
    }
}
