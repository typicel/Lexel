//VocabApp
// Created by enzo on 5/31/24

import SwiftUI
import SwiftData

struct FamiliarWordView: View {
    @Environment(\.modelContext) var modelContext
    var word: String
    var language: String
    var definition: String
    
    @Query private var vocabWordEntry: [VocabWord]
    
    private func addWordToDict() {
        let newWord = VocabWord(word: word, language: language, def: definition)
        modelContext.insert(newWord)
    }
    
    init(word: String, language: String, definition: String) {
        self.word = word
        self.language = language
        self.definition = definition
        
        self._vocabWordEntry = Query(filter: #Predicate {
            $0.word == word
        })
    }
    
    var body: some View {
        VStack {
            Text(definition)
                .font(.largeTitle)
            
            if !self.vocabWordEntry.isEmpty {
                Word(vocabWord: vocabWordEntry[vocabWordEntry.startIndex])
            } else {
                Button("Add to Dictionary") {
                    addWordToDict()
                }
                .buttonStyle(.borderedProminent)
                .padding()

            }
        }
    }
}

struct Word: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var vocabWord: VocabWord
    
    var body: some View {
        Picker("Familiarity Level", selection: $vocabWord.familiarity) {
            Text("New").tag(Familiarity.new)
            Text("Seen").tag(Familiarity.seen)
            Text("Familiar").tag(Familiarity.familiar)
            Text("Mastered").tag(Familiarity.mastered)
        }
        .pickerStyle(.segmented)
        .onChange(of: vocabWord.familiarity) {
            try! modelContext.save()
        }
        .padding()
    }
}

#Preview {
    FamiliarWordView(word: "eine", language: "de-DE", definition: "a")
}
