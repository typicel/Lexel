//
//  EditStoryView.swift
//  Lexel
//
//  Created by Tyler McCormick on 6/9/24.
//

import SwiftUI
import SwiftData

struct EditStoryView: View {
    @Bindable var story: Story
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Story Title", text: $story.title)
                    .autocorrectionDisabled()
                Picker("Source Language", selection: $story.language) {
                    ForEach(Constants.allowedLanguages.enumeratedArray(), id: \.offset) { _, lang in
                        Text(lang.0).tag(lang.1)
                    }
                }
                TextEditor(text: $story.text)
                    .frame(height: UIScreen.main.bounds.height * 0.5)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                
                PasteButton(payloadType: String.self) { string in
                    story.text = string[0]
                }
                
            }
            .navigationTitle("New Story")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                
            }
        }
    }
}

