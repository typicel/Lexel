//
//  NotesView.swift
//  Lexel
//
//  Created by enzo on 6/9/24.
//

import SwiftUI
import SwiftData

struct NotesView: View {
    @Bindable var story: Story
    
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        TextEditor(text: $story.notes)
    }
}
