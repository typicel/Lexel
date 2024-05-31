//VocabApp
// Created by enzo on 5/31/24

import SwiftUI
import SwiftData

struct FamiliarWordView: View {
    @Environment(\.modelContext) var modelContext
    let word: String
    let language: String
    let definition: String

    @Query private var vocabWordEntry: [VocabWord]
    
    @State private var fam: Familiarity = .new
    
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
        
        if !vocabWordEntry.isEmpty {
            self.fam = vocabWordEntry[0].familiarity
        }

    }
    
    var body: some View {
        VStack {
            Text(word)
                .font(.largeTitle)
            
            if vocabWordEntry.isEmpty {
                Button("Add to Dictionary") {
                    addWordToDict()
                }
            } else {
                Picker("Familiarity Level", selection: $fam) {
                    Text("New").tag(Familiarity.new)
                    Text("Seen").tag(Familiarity.seen)
                    Text("Familiar").tag(Familiarity.familiar)
                    Text("Mastered").tag(Familiarity.mastered)
                }
                .pickerStyle(.segmented)
            }
        }
    }
}
#Preview {
    FamiliarWordView(word: "eine", language: "de-DE", definition: "a")
}
