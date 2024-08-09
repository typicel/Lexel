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
    
    @ObservedObject var dataManager = DataManager.shared

    
    private func addWordToDict() {
        guard let token = svm.selectedWord, let definition = svm.translatedWord else { return }
        
        dataManager.insertDictEntry(for: token, definition: definition, language: svm.story.language)
    }
    
    var body: some View {
        if let token = svm.selectedWord, let definition = svm.translatedWord {
            if let dictEntry = token.dictionaryEntry {
                EditableWordView(entry: dictEntry)
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

struct EditableWordView: View {
    @ObservedObject var dataManager = DataManager.shared
    @State var entry: DictionaryEntry
    
    @State private var definition: String = ""
    @State private var familiarity: Int = 1
    
    init(entry: DictionaryEntry) {
        self.entry = entry
        self.configure(for: entry)
    }
    
    func configure(for entry: DictionaryEntry) {
        self.definition = entry.definition
        self.familiarity = Int(entry.familiarity)
    }
    
    func save() {
        entry.definition = definition
        entry.familiarity = Int16(familiarity)
        dataManager.save()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .firstTextBaseline) {
                Text(entry.word)
                    .font(.largeTitle)
                    .padding([.trailing])
                
                TextField("", text: $entry.definition)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .font(.title2)
            }
            

            Picker("Familiarity Level", selection: $entry.familiarity) {
                Text("New").tag(Int16(1))
                Text("Seen").tag(Int16(2))
                Text("Familiar").tag(Int16(3))
                Text("Mastered").tag(Int16(4))
            }
            .pickerStyle(.segmented)
            .onChange(of: familiarity) {
                self.save()
            }
            
            HStack {
                
                Button("Delete", systemImage: "trash") {
                    dataManager.deleteDictEntry(entry)
                }
                .font(.headline)
                .padding([.top])
                .buttonStyle(.borderedProminent)
                .tint(.red)
                
                Spacer()
            }
            
        }
        .padding(20)
        .onChange(of: entry) { oldValue, newValue in
            print("new guy found")
            self.configure(for: newValue)
        }
    }
}

//#Preview {
//    MainActor.assumeIsolated {
//        FamiliarWordView(token: Token(rawValue: "Strasse", tokenType: .word), language: "de-DE", definition: "Road")
//    }
//}
