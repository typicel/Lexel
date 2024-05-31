//
//  VocabParagraph.swift
//  VocabApp
//
//  Created by enzo on 5/24/24.
//

import SwiftUI
import MLKit

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
    @State private var selectedParagraph: Int? = nil

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
                Text(self.story.title)
                    .font(.largeTitle)
                    .bold()
                    .frame(alignment: .leading)
                Divider()
                ForEach(self.story.tokens.enumeratedArray(), id: \.offset) { poffset, paragraph in
                    FlowView(.vertical, alignment: .leading) {
                        ForEach(paragraph.enumeratedArray(), id: \.offset) { offset, element in
                                self.item(for: element, paragraph: poffset, index: offset)
                        }
                    }
                    .padding([.leading, .trailing])
                }
                .padding([.bottom, .top], 10)
                .padding([.leading, .trailing])
            }
            .frame(width: UIScreen.main.bounds.width * 0.65)
            
            Spacer()
            Divider()
            
            VStack {
                if let word = translatedWord {
                    Text(word)
                        .font(.largeTitle)
                }
            }
            .background(Color.red)
            .frame(width: UIScreen.main.bounds.width * 0.35)
            
            Spacer()
        }
    }

    
    private func translateWord(_ word: String) async {
        print("Translating \(word)")

        let translation: String? = await self.translator.getTranslation(for: word)
        self.translatedWord = translation
    }

    private func item(for word: String, paragraph: Int, index: Int) -> some View {
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
    VocabParagraph(story: Story.sampleData[3], translator: TranslationService(sourceLanguage: Story.sampleData[3].ml_language))
}
