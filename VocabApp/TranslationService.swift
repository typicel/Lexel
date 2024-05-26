//
//  TranslationManager.swift
//  VocabApp
//
//  Created by enzo on 5/24/24.
//

import Foundation
import SwiftUI
import MLKit

class TranslationService: ObservableObject {
    let translator: Translator
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
    
    func getTranslation(for word: String) async -> String? {
        
        do {
            try await self.translator.downloadModelIfNeeded(with: self.conds)
            let result = try await self.translator.translate(word)
                
            print(result)
            return result
        }
        catch {
            print("Lol")
            return ""
        }
    }
}
