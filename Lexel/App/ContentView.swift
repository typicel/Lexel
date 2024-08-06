//
//  ContentView.swift
//  Lexel
//
//  Created by enzo on 5/24/24.
//


import SwiftUI
import NaturalLanguage
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Library", systemImage: "books.vertical") {
                LibraryView()
            }
            
            Tab("Dictionary", systemImage: "character.book.closed") {
                DictionaryView()
            }
        }
        .tabViewStyle(.sidebarAdaptable)
    }
}

#Preview {
    ContentView()
}
