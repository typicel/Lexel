//
//  LexelLanguage.swift
//  Lexel
//
//  Created by Tyler McCormick on 6/11/24.
//

import Foundation
import MLKit

public struct LexelLanguage: Hashable, Codable {
    let displayName: String
    let bcp47: String
    
    public init(_ displayName: String, _ bcp47: String) {
        self.displayName = displayName
        self.bcp47 = bcp47
    }
    
    var shortName: String {
        return String(self.bcp47.suffix(2))
    }
    
    var mlLanguage: TranslateLanguage {
        switch self.bcp47 {
             case "de-DE":
                return .german
            case "en-US":
                return .english
            case "ja-JP":
                return .japanese
            case "zh-CN":
                return .chinese
            case "ko-KR":
                return .korean
            case _:
                return .english
        }
    }
    
}
