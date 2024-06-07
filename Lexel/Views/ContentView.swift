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
//        TabView {
//            LibraryView()
//                .tabItem {
//                    Image(systemName: "books.vertical")
//                    Text("Library")
//                }
//
//            DictionaryView()
//                .tabItem {
//                    Image(systemName: "bookmark")
//                    Text("Dictionary")
//                }
//
//            Text("Study")
//                .tabItem {
//                    Image(systemName: "lightbulb.max.fill")
//                    Text("Study")
//                }
//                .padding()
//
//            Text("Settings")
//                .tabItem {
//                    Image(systemName: "gear")
//                    Text("Settings")
//                }
//                .padding()
//        }
    }
}

#Preview {
    MainActor.assumeIsolated {
        ContentView()
            .modelContainer(for: [Story.self, VocabWord.self])
    }
}
