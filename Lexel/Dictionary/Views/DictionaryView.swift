//
//  DictionaryView.swift
//  Lexel
//
//  Created by enzo on 6/1/24
//

import SwiftUI
import SwiftData

struct DictionaryView: View {
    
    @Query(sort: \VocabWord.familiarityRawValue) private var words: [VocabWord]
    
    @State private var selectedEntry: VocabWord?

    var body: some View {
        NavigationSplitView {
            List(selection: $selectedEntry) {
                ForEach(words, id: \.self) { wordEntry in
                    HStack {
                        Circle()
                            .fill(Color(Constants.familiarityColors[wordEntry.familiarity.rawValue-1]))
                            .frame(width: 10, height: 10)
                        Text(wordEntry.word)
                    }
                }
            }
            .accessibilityIdentifier("dictionaryList")
        } detail: {
            if let entry = selectedEntry {
                Text(entry.word)
            } else {
                Text("no thing")
            }
        }
    }
}

#Preview {
    MainActor.assumeIsolated {
        DictionaryView()
            .modelContext(ConfigureModelContext())
    }
}
