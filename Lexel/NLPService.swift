//
//  NLPService.swift
//  Lexel
//
//  Created by Tyler McCormick on 6/9/24.
//

import Foundation
import NaturalLanguage
import MLKit

class NLPService {
    let lemma: ILemmatize
    let translator: ITranslator
    
    init(lang: TranslateLanguage) {
        self.lemma = LemmatizeService()
        self.translator = TranslationService(sourceLanguage: lang)
    }
    
    func translate(word: String) async -> String {
        return await translator.translate(word: word)
    }
    
    func lemmatize(word: String) -> String {
        return lemma.lemmatize(word: word)
    }
}
