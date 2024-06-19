//
//  NLPService.swift
//  Lexel
//
//  Created by enzo on 6/9/24.
//

import Foundation
import NaturalLanguage
import MLKit
import OSLog

class NLPService {
    let lemma: ILemmatize
    let translator: ITranslator
    
    init(lang: TranslateLanguage) {
        os_log("[LEX]: Initializing NLP service with language \(lang.rawValue)")
        self.lemma = NLLemmaService()
        self.translator = MLTranslationService(sourceLanguage: lang)
    }
    
    func translate(word: String) async -> String {
        return await translator.translate(word: word)
    }
    
    func lemmatize(word: String) -> Lemma {
        if let lemma = lemma.lemmatize(word: word) {
            return lemma
        } else {
            os_log("[LEX]: Could not lemmatize: \(word)")
            return word
        }
    }
}
