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
    
    @GestureState private var isDetectingLongPress = false
    @State private var completedLongPress = false
    @State private var selectedWord: Int? = nil
    @State private var translator: TranslationService
    private var tts: TTSService
    
    @State private var translatedWord: String? = nil
    @State private var startTranslation: Bool = false
    
    init(story: Story) {
        self.story = story
        
        self.translator = TranslationService(sourceLanguage: story.ml_language)
        self.tts = TTSService()
    }
    
    var body: some View {
        HStack {
            ScrollView {
                GeometryReader { geometry in
                    self.generateContent(in: geometry)
                }
                .ignoresSafeArea()
//                .frame(maxWidth: 800, maxHeight: .infinity)
            }
            
//            Spacer()
//            if let word = translatedWord {
//                Text(word)
//                    .font(.title)
//            }
//            Spacer()
        }
        .padding()
    }
    
    private func generateContent(in geometry: GeometryProxy) -> some View {
            var width = CGFloat.zero
            var height = CGFloat.zero
            
            return ZStack(alignment: .topLeading) {
                ForEach(Array(self.story.tokens.enumerated()), id: \.offset) { offset, element in
                    if case .word(let word) = element {
                        self.item(for: word, index: offset)
                            .padding([.horizontal, .vertical], 2.5)
                            .alignmentGuide(.leading, computeValue: { d in
                                if abs(width - d.width) > geometry.size.width {
                                    width = 0
                                    height -= d.height
                                }
                                let result = width
                                if offset == self.story.tokens.count - 1 {
                                    width = 0 // last item
                                } else {
                                    width -= d.width
                                }
                                return result
                            })
                            .alignmentGuide(.top, computeValue: { _ in
                                let result = height
                                if offset == self.story.tokens.count - 1 {
                                    height = 0 // last item
                                }
                                return result
                            })
                    } else if case .newLine = element {
                        Spacer().frame(height: 0) // Add an empty view to force a line break
                            .alignmentGuide(.leading, computeValue: { _ in
                                width = 0 // Reset width
                                return 0
                            })
                            .alignmentGuide(.top, computeValue: { _ in
                                height -= 40 // Adjust height for line break
                                return height
                            })
                    }
                }
            }
        }
    
//    private func generateContent(in geometry: GeometryProxy) -> some View {
//        var width = CGFloat.zero
//        var height = CGFloat.zero
//        
//        return ZStack(alignment: .topLeading) {
//            ForEach(self.story.words.enumeratedArray(), id: \.offset) { offset, element in
//                self.item(for: element, index: offset)
//                    .padding([.horizontal, .vertical], 2.5)
//                    .alignmentGuide(.leading, computeValue: { d in
//                        if (abs(width - d.width) > geometry.size.width) {
//                            width = 0
//                            height -= d.height
//                        }
//                        let result = width
//                        if element == self.story.words.last! {
//                            width = 0 //last item
//                        } else {
//                            width -= d.width
//                        }
//                        return result
//                    })
//                    .alignmentGuide(.top, computeValue: { _ in
//                        let result = height
//                        if element == self.story.words.last! {
//                            height = 0 // last item
//                        }
//                        return result
//                    })
//            }
//        }
//    }
    
    private func translateWord(_ word: String) async {
        print("Translating \(word)")

        let translation: String? = await self.translator.getTranslation(for: word)
        self.translatedWord = translation
    }

    private func item(for word: String, index: Int) -> some View {
        Text(word)
            .font(.title)
//            .scaleEffect(isDetectingLongPress && index == selectedWord ? 2 : 1)
//            .background(selectedWord == index ? Color.yellow : Color.clear)
            .gesture(
                LongPressGesture(minimumDuration: 0.5)
                    .updating($isDetectingLongPress) { currentState, gestureState, transaction in
                        gestureState = currentState
                        transaction.animation = Animation.easeIn(duration: 2.0)
                    }
                    .onEnded { value in
                        print("Long pressed on \(word)")
                        self.startTranslation = true
                        self.selectedWord = index
                        Task {
                            await self.translateWord(word)
                            self.tts.play(text: word, lang: self.story.language)
                        }
                    }
            )
    }
}

#Preview {
    VocabParagraph(story: Story.sampleData[3])
}
