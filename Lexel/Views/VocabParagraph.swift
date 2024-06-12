//
//  VocabParagraph.swift
//  Lexel
//
//  Created by enzo on 5/24/24.
//

import SwiftUI
import MLKit
import SwiftData
import AVFoundation
import NaturalLanguage

extension Collection {
    func enumeratedArray() -> Array<(offset: Int, element: Self.Element)> {
        return Array(self.enumerated())
    }
}

extension String {
    func stripPunctuation() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
            .trimmingCharacters(in: .punctuationCharacters)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

struct Constants {
    static let themes: [ReaderTheme] = [Clear(), Sepia(), Blue(), Gray()]
    static let fontStyles: [Font.Design] = [.default, .serif]
    static let familiarityColors: [Color] = [.new, .seen, .familiar, .mastered]
    static let allowedLanguages: [LexelLanguage] = [
        LexelLanguage("English", "en-US"),
        LexelLanguage("German", "de-DE"),
        LexelLanguage("Spanish", "es-ES"),
        LexelLanguage("French", "fr-FR"),
        LexelLanguage("Korean", "ko-KR"),
        LexelLanguage("Japanese", "ja-JP"),
    ]
}

struct VocabParagraph: View {
    @Bindable var story: Story
    
    // Environment vars
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject private var themeService: ThemeService
    
    // Natural Language and TTS
    @State var nlp: NLPService
    @State private var synthesizer: AVSpeechSynthesizer?
    
    // State relating to the currently selected word and its translation
    @State private var selectedWord: String? = nil
    @State private var selectedWordIndex: Int? = nil
    @State private var selectedParagraphIndex: Int? = nil
    @State private var translatedWord: String? = nil
    
    // Popover state vars
    @State private var showSettingsPopover: Bool = false
    @State private var showFamiliarPopover: Bool = false
    
    @State private var selectedTheme: Int = 0
    @State private var selectedFontStyle: Int = 0
    
    init(story: Story) {
        self.story = story
        self.nlp = NLPService(lang: story.language.mlLanguage)
        if let style = UserDefaults.standard.value(forKey: "readerFontStyle") {
            self.selectedFontStyle = style as! Int
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            HStack {
                Spacer()
                ScrollView(showsIndicators: false) {
                    ForEach(self.story.tokens.enumeratedArray(), id: \.offset) { poffset, paragraph in
                        FlowView(.vertical, alignment: .leading) {
                            ForEach(paragraph.enumeratedArray(), id: \.offset) { offset, element in
                                self.item(for: element, paragraph: poffset, index: offset)
                            }
                        }
                        .padding([.leading, .trailing])
                    }
                    .frame(width: geo.size.width * 0.8)
                }
                Spacer()
            }
            .background(themeService.selectedTheme.readerColor)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(self.story.title).font(.title).bold()
                        .foregroundColor(themeService.selectedTheme.textColor)
                }
                
                ToolbarItemGroup(placement: .primaryAction) {
                    Button {
                        showSettingsPopover = true
                    } label: {
                        Image(systemName: "textformat")
                    }
                    .popover(isPresented: $showSettingsPopover) {
                        VStack {
                            Picker("Font Style", selection: $selectedFontStyle) {
                                Text("Sans-Serif").tag(0)
                                Text("Serif").tag(1)
                            }
                            .pickerStyle(.segmented)
                            .onChange(of: self.selectedFontStyle) {
                                UserDefaults.standard.setValue(self.selectedFontStyle, forKey: "readerFontStyle")
                            }
                            
                            HStack {
                                ForEach(Constants.themes.enumeratedArray(), id: \.offset) { offset, theme in
                                    Circle()
                                        .stroke(offset == selectedTheme ? Color.blue : Color.gray, lineWidth: offset == selectedTheme ? 4 : 2)
                                        .fill(theme.readerColor)
                                        .frame(width: 30, height: 30)
                                        .onTapGesture {
                                            self.themeService.setTheme(theme)
                                        }
                                }
                            }
                        }
                        .padding()
                    }
                    
                }
            }
            .onAppear { // this is dumb but I need both to handle when first story is tapped on and when it changes
                story.lastOpened = Date()
            }
            .onChange(of: self.story){
                story.lastOpened = Date()
                self.nlp = NLPService(lang: story.language.mlLanguage)
            }
        }
    }
    
    /// Returns a binding that represents if the word at the given indicies is currently selected
    ///
    /// - Parameters
    ///     - wordIndex: Index of the word in each paragraph
    ///     - paragraphIndex: Index representing the paragraph the word is in
    /// - Returns: A binding representing if the word is selected
    private func makeIsPresented(wordIndex: Int, paragraphIndex: Int) -> Binding<Bool> {
        return .init(get: {
            return wordIndex == selectedWordIndex && paragraphIndex == selectedParagraphIndex
        }, set: { _ in
            self.selectedWordIndex = nil
            self.selectedParagraphIndex = nil
        })
    }
    
    /// Helper function to generate TTS for a given word
    ///
    /// - Parameters
    ///     - word: The word to be spoken
    ///     - lang: The language of the word (for accent purposes)
    func speak(text: String, lang: String){
        let utterance = AVSpeechUtterance(string: text)
        let voice = AVSpeechSynthesisVoice(language: lang)
        
        utterance.rate = 0.30
        utterance.pitchMultiplier = 0.8
        utterance.postUtteranceDelay = 0.2
        utterance.volume = 0.8
        utterance.voice = voice
        
        self.synthesizer = AVSpeechSynthesizer()
        self.synthesizer?.speak(utterance)
    }
    
    /// Handles the logic for when a word is tapped on
    /// - Parameters
    ///     - word: The word that was tapped on
    ///     - location: A tuple representing the paragraph and location within the paragraph the word is
    private func handleWordTap(for word: String, at location: (Int, Int)) async {
        let lemma = self.nlp.lemmatize(word: word.stripPunctuation()).lowercased()
        
        self.selectedWord = lemma
        self.selectedWordIndex = location.0
        self.selectedParagraphIndex = location.1
        
        self.translatedWord = await self.nlp.translate(word: lemma)
        
        self.speak(text: lemma, lang: self.story.language.bcp47)
    }
    
    private func item(for word: String, paragraph: Int, index: Int) -> some View {
        WordView(word: self.nlp.lemmatize(word: word.stripPunctuation()).lowercased(), displayWord: word, showFamiliarityHighlight: (index != selectedWordIndex || paragraph != selectedParagraphIndex))
            .font(.system(.title, design: Constants.fontStyles[self.selectedFontStyle]))
            .background(index == selectedWordIndex && selectedParagraphIndex == paragraph ? Color.yellow : Color.clear)
            .onTapGesture {
                Task {
                    await handleWordTap(for: word, at: (index, paragraph))
                }
            }
            .popover(isPresented: self.makeIsPresented(wordIndex: index, paragraphIndex: paragraph)) {
                if let definition = translatedWord {
                    FamiliarWordView(word: selectedWord!, language: story.language.bcp47, definition: definition)
                } else {
                    ProgressView()
                }
            }
        
    }
}


#Preview {
    MainActor.assumeIsolated {
        VocabParagraph(story: Story.sampleData[2])
            .modelContainer(for: [Story.self, VocabWord.self])
    }
}
