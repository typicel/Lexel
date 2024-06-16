//
//  AddStory.swift
//  Lexel-ShareExtension
//
//  Created by Tyler McCormick on 6/12/24.
//

import SwiftUI

struct AddStoryView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var context
    
//    @State private var modelManager: MLModelManager
    
    @State private var title: String = ""
    @State private var language: LexelLanguage = LexelLanguage("English", "en-US")
    @State private var storyText: String = ""
    
    
    init(text: String) {
        self.storyText = text
//        self.modelManager = MLModelManager()
    }
    
    
    func addStory() {
        let newStory = Story(title: title, text: storyText, language: language) // this is never called if language is null so it's fine
        context.insert(newStory)
//        let _ = modelManager.downloadModel(for: newStory.language.mlLanguage)
        dismiss()
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Story Title", text: $title)
                    .autocorrectionDisabled()
                Picker("Source Language", selection: $language) {
                    ForEach(Constants.allowedLanguages.enumeratedArray(), id: \.offset) { _, lang in
                        Text(lang.displayName).tag(lang)
                    }
                }
                TextEditor(text: $storyText)
                    .frame(height: UIScreen.main.bounds.height * 0.5)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                
            }
            .navigationTitle("New Story")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Add") { addStory() }
                        .disabled(title.isEmpty || storyText.isEmpty)
                }
            }
        }
    }
}
