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
    
    @EnvironmentObject var modelManager: MLModelManager
    @State private var dataManager = DataManager.shared
    
    @State private var title: String = ""
    @State private var language: Language = Constants.allowedLanguages[0]
    @State private var text: String = ""
    
    func addStory() {
        dataManager.insertStory(title: title, text: text, language: language.bcp47)
        dismiss()
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Story Title", text: $title)
                    .autocorrectionDisabled()
                    .accessibilityIdentifier("storyTitleField")
                
                Picker("Source Language", selection: $language) {
                    ForEach(Constants.allowedLanguages, id: \.self) { lang in
                        Text(lang.name).tag(lang)
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
