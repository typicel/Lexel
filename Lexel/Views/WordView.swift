//
//  WordView.swift
//  Lexel
//
//  Created by enzo on 6/9/24.
//

import SwiftUI
import SwiftData

struct WordView: View {
    let word: String
    let displayWord: String
    let showFamiliarityHighlight: Bool
    
    @Query var wordQuery: [VocabWord]
    var vocabWord: VocabWord? { wordQuery.first }
    
    init(word: String, displayWord: String, showFamiliarityHighlight: Bool) {
        self._wordQuery = Query(filter: #Predicate {
            $0.word == word
        })
        
        self.word = word
        self.displayWord = displayWord
        self.showFamiliarityHighlight = showFamiliarityHighlight
    }
    
    var body: some View {
        Text(displayWord)
            .foregroundColor(.black)
            .padding([.leading, .trailing], 0.2)
            .background(vocabWord != nil && showFamiliarityHighlight ? Constants.familiarityColors[vocabWord!.familiarity.rawValue-1] : .clear)
    }
}

