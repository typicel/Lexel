//
//  TranslationManager.swift
//  Lexel
//
//  Created by enzo on 5/24/24.
//

import Foundation
import SwiftUI
import MLKit

protocol ITranslator {
    func translate(word: String) async -> String
}

class TranslationService: ObservableObject, ITranslator {
    
    var translator: Translator
    var source: TranslateLanguage
    var target: TranslateLanguage
    
    let conds = ModelDownloadConditions(allowsCellularAccess: true, allowsBackgroundDownloading: true)

    init(sourceLanguage: TranslateLanguage) {
        
        let toptions = TranslatorOptions(sourceLanguage: sourceLanguage, targetLanguage: .english)
        let translate = Translator.translator(options: toptions)
        
        self.source = sourceLanguage
        self.target = .english
        self.translator = translate
    }
    
    func setSourceTranslation(lang: TranslateLanguage) {
        let toptions = TranslatorOptions(sourceLanguage: lang, targetLanguage: .english)
        let translate = Translator.translator(options: toptions)
        
        self.translator = translate
    }
    
    func translate(word: String) async -> String {
        do {
            try await self.translator.downloadModelIfNeeded(with: self.conds)
            let result = try await self.translator.translate(word)
                
            print(result)
            return result
        }
        catch {
            print(error)
            return ""
        }
    }
}
