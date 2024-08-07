//
//  WordView.swift
//  Lexel
//
//  Represents each tapable word in a VocabParagraph View
//
//  Created by enzo on 6/9/24.
//

import SwiftUI
import SwiftData

//struct WordView: View {
//    @EnvironmentObject var themeManager: ThemeService
//    @Environment(\.colorScheme) var colorScheme
//    
//    let word: String
//    let displayWord: String
//    let showFamiliarityHighlight: Bool
//    
//    init(word: String, displayWord: String, showFamiliarityHighlight: Bool) {
//        self.word = word
//        self.displayWord = displayWord
//        self.showFamiliarityHighlight = showFamiliarityHighlight
//    }
//    
//    var body: some View {
//        Text(displayWord)
//            .font(self.themeManager.selectedFont.readerFont)
//            .foregroundColor(
//                themeManager.selectedTheme.textColor != nil ? themeManager.selectedTheme.textColor :
//                    (colorScheme == .dark ? .white : .black)
//            )
//            .padding([.leading, .trailing], 0.2)
//            .background(wordQuery.count > 0 && showFamiliarityHighlight ? Constants.familiarityColors[wordQuery[0].familiarity-1] : .clear)
//    }
//}

