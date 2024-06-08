//
//  ContentView.swift
//  VocabApp
//
//  Created by enzo on 5/24/24.
//


import SwiftUI
import NaturalLanguage
import SwiftData

struct ContentView: View {
    var body: some View {
        LibraryView()
    }
}

#Preview {
    MainActor.assumeIsolated {
        ContentView()
            .modelContainer(for: [Story.self, VocabWord.self])
    }
}
