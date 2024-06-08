//
//  VocabParagraph.swift
//  Lexel
//
//  Created by enzo on 5/24/24.
//

import SwiftUI
import MLKit
import SwiftData

extension Collection {
    func enumeratedArray() -> Array<(offset: Int, element: Self.Element)> {
        return Array(self.enumerated())
    }
}

let colors: [Color] = [.clear, .readerBeige, .readerBlue, .readerGray]
let fontStyles: [Font.Design] = [.default, .serif]

struct VocabParagraph: View {
    @Bindable var story: Story
    let translator: TranslationService
    private var tts: TTSService
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var colorScheme
    
    @State private var selectedWord: String? = nil
    @State private var selectedWordIndex: Int? = nil
    @State private var selectedParagraphIndex: Int? = nil
    
    @State private var translatedWord: String? = nil
    @State private var startTranslation: Bool = false
    
    @State private var showSettingsPopover: Bool = false
    
    @AppStorage("readerColor") var selectedColor: Int = 0
    @AppStorage("readerFontStyle") var selectedFontStyle: Int = 0
    
    init(story: Story, translator: TranslationService) {
        self.story = story
        self.tts = TTSService()
        self.translator = translator
    }
    
    var body: some View {
        HStack {
            ScrollView {
                HStack{
                    Spacer()
                    
                    Text(self.story.title)
                        .font(.largeTitle)
                        .bold()
                        .frame(alignment: .leading)
                    
                    Spacer()
                    
                    Button {
                        showSettingsPopover = true
                    } label: {
                        Image(systemName: "textformat")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    }
                    .padding([.trailing])
                    .padding()
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
                                ForEach(colors.enumeratedArray(), id: \.offset) { offset, color in
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
                        .background (
                            colorScheme == .dark ? Color.black.opacity(0.8) : Color.white.opacity(0.8)
                            
                        )
                        .padding()
                    }
                    
                }
                
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
            .background(colors[selectedColor])
            .frame(width: UIScreen.main.bounds.width * 0.65)
            
            VStack {
                if let definition = translatedWord {
                    FamiliarWordView(word: selectedWord!, language: story.language, definition: definition)
                        .padding()
                } else {
                    Spacer(minLength: UIScreen.main.bounds.height * 0.50)
                }
                
                Spacer()
                Divider()
                
                NotesView(story: story)
                    .frame(height: UIScreen.main.bounds.height * 0.50)
            }
            .frame(width: UIScreen.main.bounds.width * 0.35)
            
            Spacer()
        }
        .onAppear { // this is dumb but I need both to handle when first story is tapped on and when it changes
            story.lastOpened = Date()
            try! modelContext.save()
        }
        .onChange(of: self.story){
            story.lastOpened = Date()
            try! modelContext.save()
        }
    }
    
    private func translateWord(_ word: String) async {
        let translation: String? = await self.translator.getTranslation(for: word)
        self.translatedWord = translation
    }
    
    private func item(for word: String, paragraph: Int, index: Int) -> some View {
        Text(word)
            .font(.system(.title, design: fontStyles[self.selectedFontStyle]))
            .background(index == selectedWordIndex && selectedParagraphIndex == paragraph ? Color.yellow : Color.clear)
            .onTapGesture {
                self.startTranslation = true
                self.selectedWordIndex = index
                self.selectedWord = word
                self.selectedParagraphIndex = paragraph
                Task {
                    await self.translateWord(word)
                    self.tts.play(text: word, lang: self.story.language)
                }
            }
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
        VocabParagraph(story: Story.sampleData[3], translator: TranslationService(sourceLanguage: Story.sampleData[3].mlLanguage))
            .modelContainer(for: [Story.self, VocabWord.self])
    }
}
