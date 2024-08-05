//
//  EditStoryView.swift
//  Lexel
//
//  Created by enzo on 6/9/24.
//

import SwiftUI
import SwiftData

struct EditStoryView: View {
    var body: some View {
        Text("Edit story")
    }
//    @Bindable var story: Story
//    
//    @Environment(\.dismiss) var dismiss
//    @Environment(\.modelContext) var modelContext
//    
//    var body: some View {
//        NavigationStack {
//            Form {
//                TextField("Story Title", text: $story.title)
//                    .autocorrectionDisabled()
//                Picker("Source Language", selection: $story.language) {
//                    ForEach(Constants.allowedLanguages.enumeratedArray(), id: \.offset) { _, lang in
//                        Text(lang.displayName).tag(lang)
//                    }
//                }
//                
//                TextEditor(text: $story.text)
//                    .frame(height: UIScreen.main.bounds.height * 0.5)
//                    .autocorrectionDisabled()
//                    .textInputAutocapitalization(.never)
//                
//            }
//            .navigationTitle("Edit \"\(story.title)\"")
//            .navigationBarTitleDisplayMode(.large)
//            .toolbar {
//                ToolbarItemGroup(placement: .topBarLeading) {
//                    Button("Cancel") { dismiss() }
//                }
//                
//                ToolbarItemGroup(placement: .topBarTrailing) {
//                    Button("Save") {
//                        try! modelContext.save()
//                        dismiss()
//                    }
//                }
//            }
//        }
//    }
}

