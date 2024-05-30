//
//  VocabParagraph.swift
//  VocabApp
//
//  Created by enzo on 5/24/24.
//

import SwiftUI
import MLKit
import SwiftUIFlow

extension Collection {
    func enumeratedArray() -> Array<(offset: Int, element: Self.Element)> {
        return Array(self.enumerated())
    }
}

struct VocabParagraph: View {
    let story: Story
    let translator: TranslationService
    
    private var tts: TTSService

    @GestureState private var isDetectingLongPress = false
    @State private var completedLongPress = false
    @State private var selectedWord: Int? = nil
    
    @State private var translatedWord: String? = nil
    @State private var startTranslation: Bool = false
    
    init(story: Story, translator: TranslationService) {
        self.story = story
        self.tts = TTSService()
        self.translator = translator
    }
    
    var body: some View {
        HStack {
            ScrollView {
                ForEach(self.story.tokens, id: \.self) { paragraph in
                    VFlow(alignment: .leading) {
                        ForEach(paragraph.enumeratedArray(), id: \.offset) { offset, element in
                            self.item(for: element, index: offset)
                        }
                    }
                }
                .padding()
            }
//            .frame(width: UIScreen.main.bounds.width * 0.75)
            
            Spacer()
            
            VStack {
                if let word = translatedWord {
                    Text(word)
                        .font(.title)
                        .background(Color.blue)
                }
            }
            .background(Color.red)
            
            Spacer()
        }
    }

    
    private func translateWord(_ word: String) async {
        print("Translating \(word)")

        let translation: String? = await self.translator.getTranslation(for: word)
        self.translatedWord = translation
    }

    private func item(for word: String, index: Int) -> some View {
        Text(word)
            .font(.title)
            .onTapGesture {
                print("Long pressed on \(word)")
                self.startTranslation = true
                self.selectedWord = index
                Task {
                    await self.translateWord(word)
                    self.tts.play(text: word, lang: self.story.language)
                }
            }
    }
}

#Preview {
    VocabParagraph(story: Story.sampleData[3], translator: TranslationService(sourceLanguage: Story.sampleData[3].ml_language))
}
