//
//  FamiliarWordView.swift
//  Lexel
//
//  Created by enzo on 5/31/24
//

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
        if !self.vocabWordEntry.isEmpty {
            Word(vocabWord: vocabWordEntry[vocabWordEntry.startIndex])
        } else {
            VStack(alignment: .leading) {
                HStack(alignment: .firstTextBaseline) {
                    Text(word)
                        .font(.largeTitle)
                    
                    Text(definition)
                        .font(.title2)
                }
                
                
                Button("Add to Dictionary") {
                    addWordToDict()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(20)
        }
    }
}

struct Word: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var vocabWord: VocabWord
    
    var body: some View {
        VStack {
            HStack(alignment: .firstTextBaseline) {
                Text(vocabWord.word)
                    .font(.largeTitle)
                    .padding([.trailing])
                
                TextField("", text: $vocabWord.definition)
                    .onChange(of: vocabWord.definition) {
                        try! modelContext.save()
                    }
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .font(.title2)
            }
            
            Picker("Familiarity Level", selection: $vocabWord.familiarity) {
                HStack {
                    Circle()
                        .fill(.red)
                        .frame(width: 10, height: 10)
                        
                    Text("New")
                }
                .tag(Familiarity.new)
                
                Text("Seen").tag(Familiarity.seen)
                Text("Familiar").tag(Familiarity.familiar)
                Text("Mastered").tag(Familiarity.mastered)
            }
            .pickerStyle(.segmented)
            .onChange(of: vocabWord.familiarity) {
                try! modelContext.save()
            }
            
            HStack {
                
                Button("Delete", systemImage: "trash") {
                    modelContext.delete(vocabWord)
                    try! modelContext.save()
                }
                .font(.headline)
                .padding([.top])
                .buttonStyle(.borderedProminent)
                .tint(.red)
                
                Spacer()
            }
            
        }
        .padding(20)
    }
}

#Preview {
    MainActor.assumeIsolated {
        FamiliarWordView(word: "Strasse", language: "de-DE", definition: "Road")
            .modelContainer(for: [Story.self, VocabWord.self])
    }
}
