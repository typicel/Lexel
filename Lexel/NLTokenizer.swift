//
//  NLTokenizer.swift
//  Lexel
//
//  Created by Tyler McCormick on 6/18/24.
//

import Foundation
import NaturalLanguage
import OSLog

struct LexelToken {
    let rawValue: String
//    let range: Range<String.Index>
    let tokenType: NLTag
    
    var normalizedWord: String {
        return rawValue.stripPunctuation().lowercased()
    }
}

// Only issue with this tokenizer is that it just doesn't seem to care about punctuation
extension String {
    func nlTokenize(unit: NLTokenUnit) -> [LexelToken] {
        let tokenizer = NLTagger(tagSchemes: [.tokenType])
        tokenizer.string = self
        
        var tokens: [LexelToken] = []
        tokenizer.enumerateTags(in: self.startIndex..<self.endIndex, unit: unit, scheme: .tokenType) { tag, tokenRange in
            let token = LexelToken(
                rawValue: String(self[tokenRange]),
                tokenType: tag ?? .word
            )
            tokens.append(token)
            return true
        }
        
        return tokens
    }
    
}
