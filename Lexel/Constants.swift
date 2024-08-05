//
//  Constants.swift
//  Lexel
//
//  Created by Tyler McCormick on 6/18/24.
//

import Foundation
import SwiftUI

public enum Constants {
    static let themes: [ReaderTheme] = [Clear(), Sepia(), Blue(), Gray()]
    static let fontStyles: [ReaderFont] = [SanFrancisco(), NewYork(), Lora()]
    static let familiarityColors: [Color] = [.new, .seen, .familiar, .mastered]
    static let allowedLanguages: [Language] = [
        Language("English", "en-US"),
        Language("German", "de-DE"),
        Language("Spanish", "es-ES"),
        Language("French", "fr-FR"),
        Language("Korean", "ko-KR"),
        Language("Japanese", "ja-JP"),
    ]
}

enum Familiarity: Int, Codable {
    case new = 1
    case seen = 2 
    case familiar = 3
    case mastered = 4
}
