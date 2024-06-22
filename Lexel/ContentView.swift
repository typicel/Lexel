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
        LibraryView()
    }
}

#Preview {
    MainActor.assumeIsolated {
        ContentView()
            .modelContext(ConfigureModelContext())
    }
}
