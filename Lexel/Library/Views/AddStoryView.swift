//
//  AddStoryView.swift
//  Lexel
//
//  Created by enzo on 6/11/24.
//

import SwiftUI
import OSLog

struct AddStoryView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var context
    
    @EnvironmentObject var modelManager: MLModelManager
    
    @State private var title: String = ""
    @State private var language: LexelLanguage = LexelLanguage("English", "en-US")
    @State private var text: String = "Add story text here"
    
    
    func addStory() {
        let newStory = Story(title: title, text: text, language: language)
        context.insert(newStory)
        do {
            try context.save()
        } catch {
            os_log("[LEX]: \(error.localizedDescription)")
        }
        
        let _ = modelManager.downloadModel(for: newStory.language.mlLanguage)
        dismiss()
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Story Title", text: $title)
                    .autocorrectionDisabled()
                    .accessibilityIdentifier("storyTitleField")
                
                Picker("Source Language", selection: $language) {
                    ForEach(Constants.allowedLanguages.enumeratedArray(), id: \.offset) { _, lang in
                        Text(lang.displayName).tag(lang)
                    }
                }
                .accessibilityIdentifier("storyLangPicker")
                
                TextEditor(text: $text)
                    .frame(height: UIScreen.main.bounds.height * 0.5)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .accessibilityIdentifier("storyTextField")
                
            }
            .navigationTitle("Add New Story")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Add") { addStory() }
                        .disabled(title.isEmpty || text.isEmpty)
                        .accessibilityIdentifier("addStory")
                }
            }
        }
    }
}

#Preview {
    AddStoryView()
        .environmentObject(MLModelManager())
}
