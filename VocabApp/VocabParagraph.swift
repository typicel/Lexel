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
    let words: [String]
    
    @GestureState private var isDetectingLongPress = false
    @State private var completedLongPress = false
    @State private var selectedWord: Int? = nil
    @State private var translator: TranslationService
    
    @State private var translatedWord: String? = nil
    @State private var startTranslation: Bool = false
    
    init(story: Story) {
        self.story = story
        self.words = story.text.split(separator: " ").map { String($0) }
        
        self.translator = TranslationService(sourceLanguage: story.language)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            GeometryReader { geometry in
                self.generateContent(in: geometry)
            }
            
            if let word = translatedWord {
                Text(word)
            }
        }
        .padding()
    }
    
    private func generateContent(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            ForEach(self.words.enumeratedArray(), id: \.offset) { offset, element in
                self.item(for: element, index: offset)
                    .padding([.horizontal, .vertical], 2.5)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > geometry.size.width) {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if element == self.words.last! {
                            width = 0 //last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { _ in
                        let result = height
                        if element == self.words.last! {
                            height = 0 // last item
                        }
                        return result
                    })
            }
        }
    }
    
    private func translateWord(_ word: String) async {
        print("Translating \(word)")

        let translation: String? = await self.translator.getTranslation(for: word)
        print(translation!)
        self.translatedWord = translation
    }

    private func item(for word: String, index: Int) -> some View {
        Text(word)
            .font(.title)
            .scaleEffect(isDetectingLongPress && index == selectedWord ? 2 : 1)
            .gesture(
                LongPressGesture(minimumDuration: 0.5)
                    .updating($isDetectingLongPress) { currentState, gestureState, transaction in
                        gestureState = currentState
                        self.selectedWord = index
                        transaction.animation = Animation.easeIn(duration: 2.0)
                    }
                    .onEnded { value in
                        print("Long pressed on \(word)")
                        self.startTranslation = true
                        Task {
                            await self.translateWord(word)
                        }
                    }
            )
    }
}

let story = Story(title: "Test Title", text: "Ricarda ist 21 Jahre alt und wohnt in Lübeck. Lübeck ist eine sehr schöne Stadt im Norden von Deutschland. Ricarda studiert Medizin an der Universität von Lübeck. Sie hat viele Freunde dort.", language: .german)

#Preview {
    VocabParagraph(story: story)
}
