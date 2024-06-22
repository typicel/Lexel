//
//  LexelLanguage.swift
//  Lexel
//
//  Created by Tyler McCormick on 6/11/24.
//

import Foundation
import MLKit

public struct LexelLanguage: Hashable, Codable {
    /// Display name of the language, to be shown to the user
    let displayName: String
    
    /// BCP-47 tag for the language (en-US, de-DE, ko-KR, etc.)
    let bcp47: String
    
    /// Converts BCP-47 to  2-char language representation
    var shortName: String {
        return String(self.bcp47.suffix(2))
    }
    
    /// Google MLKit language representation
    var mlLanguage: TranslateLanguage {
        switch self.bcp47 {
        case "de-DE":
            return .german
        case "en-US":
            return .english
        case "fr-FR":
            return .french
        case "ja-JP":
            return .japanese
        case "zh-CN":
            return .chinese
        case "ko-KR":
            return .korean
        case "es-ES":
            return .spanish
        case _:
            return .english
        }
    }
    
    public init(_ displayName: String, _ bcp47: String) {
        self.displayName = displayName
        self.bcp47 = bcp47
    }
    
}

extension LexelLanguage {
    func toJSON() -> Data? {
        return try? JSONEncoder().encode(self)
    }
    
    func fromJSON(_ data: Data) -> LexelLanguage? {
        return try? JSONDecoder().decode(LexelLanguage.self, from: data)
    }
}
