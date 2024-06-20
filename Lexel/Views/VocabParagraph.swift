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
import Translation



struct VocabParagraph: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject private var themeService: ThemeService
    
    @Bindable var story: Story
    
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
    
    init(story: Story) {
        self.story = story
        self.nlp = NLPService(lang: story.language.mlLanguage)
    }
    
    var body: some View {
        GeometryReader { geo in
            HStack {
                Spacer()
                ScrollView(showsIndicators: false) {
                    ForEach(self.story.tokens.enumeratedArray(), id: \.offset) { poffset, paragraph in
                        FlowView(.vertical, alignment: .leading, horizontalSpacing: 0) {
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
                Toolbar(story: self.story, themeService: self.themeService)
            }
            .onAppear { // this is dumb but I need both to handle when first story is tapped on and when it changes
                story.lastOpened = Date()
            }
            .onChange(of: self.story){
                story.lastOpened = Date()
                self.nlp = NLPService(lang: story.language.mlLanguage)
            }
        }
        .environmentObject(self.themeService)
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
    private func handleWordTap(for token: LexelToken, at location: (Int, Int)) async {
        let lemma = self.nlp.lemmatize(word: token.normalizedWord)
        
        self.selectedWord = lemma
        self.selectedWordIndex = location.0
        self.selectedParagraphIndex = location.1
        
        self.translatedWord = await self.nlp.translate(word: lemma)
        
        self.speak(text: lemma, lang: self.story.language.bcp47)
    }
    
    private func prepareWord(_ word: String) -> String {
        self.nlp.lemmatize(word: word.stripPunctuation()).lowercased()
    }
    
    private func item(for token: LexelToken, paragraph: Int, index: Int) -> some View {
        WordView(word: token.normalizedWord, displayWord: token.rawValue, showFamiliarityHighlight: (index != selectedWordIndex || paragraph != selectedParagraphIndex))
            .background(index == selectedWordIndex && selectedParagraphIndex == paragraph ? Color.yellow : Color.clear)
            .onTapGesture {
                guard token.tokenType == .word else { return }
                        
                Task {
                    await handleWordTap(for: token, at: (index, paragraph))
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

struct Toolbar: ToolbarContent {
    let themeService: ThemeService
    let story: Story
    
    // MARK: Figure out how to set selectedFont on init
    @State private var selectedFont: Int = 0
    @State private var showSettingsPopover: Bool = false
    
    init(story: Story, themeService: ThemeService) {
        self.story = story
        self.themeService = themeService
        
        switch themeService.selectedFont { // this is stupid but so am i
        case is SanFrancisco:
            self.selectedFont = 0
        case is NewYork:
            self.selectedFont = 1
        case is Lora:
            self.selectedFont = 2
        case _:
            self.selectedFont = 0
        }
    }
    
    var body: some ToolbarContent {
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
                    Picker("Font Style", selection: self.$selectedFont) {
                        ForEach(Constants.fontStyles.enumeratedArray(), id: \.offset) { offset, font in
                            Text(font.name).tag(offset)
                        }
                    }
                    .pickerStyle(.automatic)
                    .onChange(of: self.selectedFont) {
                        self.themeService.setFont(Constants.fontStyles[self.selectedFont])
                    }
                    
                    HStack {
                        ForEach(Constants.themes.enumeratedArray(), id: \.offset) { offset, theme in
                            Circle()
                                .stroke(theme.name == self.themeService.selectedTheme.name ? Color.blue : Color.gray, lineWidth: theme.name == self.themeService.selectedTheme.name ? 4 : 2)
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
}


#Preview {
    MainActor.assumeIsolated {
        VocabParagraph(story: Story.sampleData[2])
            .modelContainer(for: [Story.self, VocabWord.self])
    }
}
