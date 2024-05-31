//VocabApp
// Created by enzo on 5/30/24

import SwiftUI

struct VocabWordView: View {
    
    
    var body: some View {
         Text(word)
            .font(.title)
            .background(index == selectedWord && selectedParagraph == paragraph ? Color.yellow : Color.clear)
            .onTapGesture {
                print("Long pressed on \(word)")
                self.startTranslation = true
                self.selectedWord = index
                self.selectedParagraph = paragraph
                Task {
                    await self.translateWord(word)
                    self.tts.play(text: word, lang: self.story.language)
                }
            }
    }
}

#Preview {
    VocabWordView()
}
