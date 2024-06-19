//
//  Constants.swift
//  Lexel
//
//  Created by Tyler McCormick on 6/18/24.
//

import Foundation
import SwiftUI

public struct Constants {
    static let themes: [ReaderTheme] = [Clear(), Sepia(), Blue(), Gray()]
    static let fontStyles: [ReaderFont] = [SanFrancisco(), NewYork(), Lora()]
    static let familiarityColors: [Color] = [.new, .seen, .familiar, .mastered]
    static let allowedLanguages: [LexelLanguage] = [
        LexelLanguage("English", "en-US"),
        LexelLanguage("German", "de-DE"),
        LexelLanguage("Spanish", "es-ES"),
        LexelLanguage("French", "fr-FR"),
        LexelLanguage("Korean", "ko-KR"),
        LexelLanguage("Japanese", "ja-JP"),
    ]
}

enum Familiarity: Int, Codable {
    case new = 1
    case seen = 2 
    case familiar = 3
    case mastered = 4
}
