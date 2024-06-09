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
    static let colors: [Color] = [.clear, .readerBeige, .readerBlue, .readerGray]
    static let fontStyles: [Font.Design] = [.default, .serif]
    static let familiarityColors: [Color] = [.new, .seen, .familiar, .mastered]
}

struct VocabParagraph: View {
    @Bindable var story: Story
    let translator: TranslationService
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var colorScheme
    
    @State private var synthesizer: AVSpeechSynthesizer?
    
    @State private var selectedWord: String? = nil
    @State private var selectedWordIndex: Int? = nil
    @State private var selectedParagraphIndex: Int? = nil
    
    @State private var translatedWord: String? = nil
    @State private var startTranslation: Bool = false
    
    @State private var showSettingsPopover: Bool = false
    @State private var showFamiliarPopover: Bool = false
    
    @AppStorage("readerColor") var selectedColor: Int = 0
    @State private var selectedFontStyle: Int = 0
    
    init(story: Story, translator: TranslationService) {
        self.story = story
        self.translator = translator
        if let style = UserDefaults.standard.value(forKey: "readerFontStyle") {
            self.selectedFontStyle = style as! Int
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            HStack {
                Spacer()
                ScrollView {
                    ForEach(self.story.tokens.enumeratedArray(), id: \.offset) { poffset, paragraph in
                        FlowView(.vertical, alignment: .leading) {
                            ForEach(paragraph.enumeratedArray(), id: \.offset) { offset, element in
                                self.item(for: element, paragraph: poffset, index: offset)
                            }
                        }
                        .padding([.leading, .trailing])
                    }
                    .frame(width: geo.size.width * 0.8)
                    .padding([.bottom, .top], 10)
                    .padding([.leading, .trailing])
                }
                Spacer()
            }
            .background(Constants.colors[selectedColor])
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(self.story.title).font(.title).bold()
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
                                ForEach(Constants.colors.enumeratedArray(), id: \.offset) { offset, color in
                                    Circle()
                                        .stroke(offset == selectedColor ? Color.blue : Color.gray, lineWidth: offset == selectedColor ? 4 : 2)
                                        .fill(color)
                                        .frame(width: 30, height: 30)
                                        .onTapGesture {
                                            UserDefaults.standard.setValue(offset, forKey: "readerColor")
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
            }
        }
    }
    
    private func translateWord(_ word: String) async {
        let translation: String? = await self.translator.getTranslation(for: word)
        self.translatedWord = translation
    }
    
    private func makeIsPresented(wordIndex: Int, paragraphIndex: Int) -> Binding<Bool> {
        return .init(get: {
            return wordIndex == selectedWordIndex && paragraphIndex == selectedParagraphIndex
        }, set: { _ in
            self.selectedWordIndex = nil
            self.selectedParagraphIndex = nil
        })
    }
    
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
    
    private func item(for word: String, paragraph: Int, index: Int) -> some View {
        WordView(word: word.stripPunctuation(), displayWord: word, showFamiliarityHighlight: (index != selectedWordIndex || paragraph != selectedParagraphIndex))
            .font(.system(.title, design: Constants.fontStyles[self.selectedFontStyle]))
            .background(index == selectedWordIndex && selectedParagraphIndex == paragraph ? Color.yellow : Color.clear)
            .onTapGesture {
                self.selectedWord = word.stripPunctuation()
                self.selectedWordIndex = index
                self.selectedParagraphIndex = paragraph
                Task {
                    await self.translateWord(word.stripPunctuation())
                    self.speak(text: word, lang: self.story.language)
                }
            }
            .popover(isPresented: self.makeIsPresented(wordIndex: index, paragraphIndex: paragraph)) {
                if let definition = translatedWord {
                    FamiliarWordView(word: selectedWord!, language: story.language, definition: definition)
                } else {
                    ProgressView()
                }
            }
        
    }
}

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

struct NotesView: View {
    @Bindable var story: Story
    
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        TextEditor(text: $story.notes)
            .onChange(of: story.notes) {
                try! modelContext.save()
            }
    }
}


#Preview {
    MainActor.assumeIsolated {
        VocabParagraph(story: Story.sampleData[2], translator: TranslationService(sourceLanguage: Story.sampleData[2].mlLanguage))
            .modelContainer(for: [Story.self, VocabWord.self])
    }
}
