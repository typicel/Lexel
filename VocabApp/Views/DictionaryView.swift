//VocabApp
// Created by enzo on 6/1/24

import SwiftUI
import SwiftData

struct DictionaryView: View {
    @Query var dictEntries: [VocabWord]
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(dictEntries) { entry in
                    NavigationLink(value: entry) {
                        Text(entry.word)
                    }
                }
            }
            .listStyle(.inset)
            .navigationTitle("Dictionary")
            .navigationDestination(for: VocabWord.self) {
                Text($0.word)
            }
        } detail: {
          if dictEntries.isEmpty {
                ContentUnavailableView(label: {
                    Label("No Stories", systemImage: "book")
                }, description: {
                    Text("Add a story to start learning")
                })
            }
        }
        .navigationSplitViewStyle(.automatic)
    }
}

#Preview {
    MainActor.assumeIsolated {
        DictionaryView()
            .modelContainer(for: [VocabWord.self])
    }
}
