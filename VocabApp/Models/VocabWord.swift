//VocabApp
// Created by enzo on 5/30/24

import Foundation
import SwiftData

enum Familiarity: Int, Codable {
    case new = 1
    case seen = 2 
    case familiar = 3
    case mastered = 4
}

@Model
class VocabWord {
    @Attribute(.unique) let word: String
    let language: String
    var familiarity: Familiarity
    var definition: String
    var timesTapped: Int
    
    init(word: String, language: String, def: String) {
        self.word = word
        self.language = language
        self.definition = def
        self.timesTapped = 0
        self.familiarity = .new
    }
    
    func setFamiliarity(to newFam: Familiarity) {
        self.familiarity = newFam
    }
    
    func setDefinition(to newDef: String) {
        self.definition = newDef
    }
}
