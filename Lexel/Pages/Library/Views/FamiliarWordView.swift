//
//  FamiliarWordView.swift
//  Lexel
//
//  Created by enzo on 5/31/24
//

import SwiftUI
import OSLog

struct FamiliarWordView: View {
    @EnvironmentObject var svm: StoryViewModel
    @ObservedObject var dataManager = DataManager.preview
    
    private func addWordToDict() {
        guard let token = svm.selectedWord, let definition = svm.translatedWord else { return }
        
        let dict = dataManager.insertDictEntry(word: token.value.lowercased(), definition: definition, language: svm.story.language)
        token.dictionaryEntry = dict
    }
    
    var body: some View {
        if let token = svm.selectedWord, let definition = svm.translatedWord {
            if let dictEntry = token.dictionaryEntry {
                Text(dictEntry.word!)
            } else {
                VStack(alignment: .leading) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(token.value)
                            .font(.largeTitle)
                        Text(definition)
                            .font(.title2)
                    }
                    
                    Button("Add to Dictionary") {
                        addWordToDict()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        } else {
            Text("")
                .frame(width: 400)
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
