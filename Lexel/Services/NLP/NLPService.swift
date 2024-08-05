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
    static let shared = NLPService()
    
    func translate(word: String, from lang: String) async -> String {
        var mllang: TranslateLanguage = .english
        switch lang {
             case "de-DE", "german":
                mllang = .german
            case "en-US", "english":
                mllang = .english
            case "fr-FR", "french":
                mllang = .french
            case "ja-JP", "japanese":
                mllang = .japanese
            case "zh-CN", "chinese":
                mllang = .chinese
            case "ko-KR", "korean":
                mllang = .korean
            case "es-ES", "spanish":
                mllang = .spanish
            case _:
                mllang = .english
        }
        
        let translator = MLTranslationService(sourceLanguage: mllang)
        return await translator.translate(word: word)
    }
    
    func lemmatize(word: String) -> Lemma {
        let lemma = NLLemmaService()
        if let lemma = lemma.lemmatize(word: word) {
            return lemma
        } else {
            os_log("[LEX]: Could not lemmatize: \(word)")
            return word
        }
    }
}
