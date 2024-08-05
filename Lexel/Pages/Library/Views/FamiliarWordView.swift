//
//  FamiliarWordView.swift
//  Lexel
//
//  Created by enzo on 5/31/24
//

import SwiftUI
import OSLog

struct FamiliarWordView: View {
    @Environment(\.modelContext) var modelContext
    var token: Token
    var language: String
    var definition: String
   
//    var isLexeme: Bool {
//        return token.lemma != token.normalizedWord
//    }
    
    @State private var translation: String? = nil
    
    private func addWordToDict() {
//        let newWord = VocabWord(word: token.lemma, language: language, def: definition)
//        if isLexeme {
//            newWord.appendLexeme(word: token.normalizedWord)
//        }
//        modelContext.insert(newWord)
//        try! modelContext.save()
    }
    
    init(token: Token, language: String, definition: String) {
        self.token = token
        self.language = language
        self.definition = definition
    }
    
    var body: some View {
        if let dictEntry = token.dictionaryEntry {
            Text(dictEntry.word!)
        } else {
            VStack(alignment: .leading) {
//                if isLexeme {
//                    Text("\(token.normalizedWord) is a lexeme of:")
//                        .font(.caption)
//                        .italic()
//                }
                
                HStack(alignment: .firstTextBaseline) {
                    Text(token.value!)
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

//struct EditableWorldView: View {
//    @Environment(\.modelContext) var modelContext
//    var vocabWord: DictionaryEntry
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            HStack(alignment: .firstTextBaseline) {
//                Text(vocabWord.word)
//                    .font(.largeTitle)
//                    .padding([.trailing])
//                
//                TextField("", text: $vocabWord.definition)
//                    .autocorrectionDisabled()
//                    .textInputAutocapitalization(.never)
//                    .font(.title2)
//            }
//            
//            HStack {
//                ForEach(Array(vocabWord.lexeme), id: \.self) { l in
//                    LexemePill(text: l.string)
//                }
//            }
//            
//            Picker("Familiarity Level", selection: $vocabWord.familiarityRawValue) {
//                HStack {
//                    Circle()
//                        .fill(.red)
//                        .frame(width: 10, height: 10)
//                        
//                    Text("New")
//                }
//                .tag(1)
//                
//                Text("Seen").tag(2)
//                Text("Familiar").tag(3)
//                Text("Mastered").tag(4)
//            }
//            .pickerStyle(.segmented)
//            .onChange(of: vocabWord.familiarity) {
//                try! modelContext.save()
//            }
//            
//            HStack {
//                
//                Button("Delete", systemImage: "trash") {
//                    modelContext.delete(vocabWord)
//                    try! modelContext.save()
//                }
//                .font(.headline)
//                .padding([.top])
//                .buttonStyle(.borderedProminent)
//                .tint(.red)
//                
//                Spacer()
//            }
//            
//        }
//        .padding(20)
//    }
//}

//#Preview {
//    MainActor.assumeIsolated {
//        FamiliarWordView(token: Token(rawValue: "Strasse", tokenType: .word), language: "de-DE", definition: "Road")
//    }
//}
