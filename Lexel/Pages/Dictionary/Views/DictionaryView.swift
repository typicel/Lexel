//
//  DictionaryView.swift
//  Lexel
//
//  Created by enzo on 6/1/24
//

import SwiftUI
import SwiftData

struct DictionaryView: View {
    
    @StateObject var viewModel = DictionaryViewModel()
    @State private var selectedEntry: DictionaryEntry?

    var body: some View {
        NavigationSplitView {
            List(selection: $selectedEntry) {
                ForEach(viewModel.words, id: \.self) { wordEntry in
                    HStack {
                        Circle()
                            .fill(Color(Constants.familiarityColors[Int(wordEntry.familiarity)-1]))
                            .frame(width: 10, height: 10)
                        Text(wordEntry.word!)
                    }
                }
            }
            .accessibilityIdentifier("dictionaryList")
        } detail: {
            if let entry = selectedEntry {
                Text(entry.word!)
            } else {
                Text("no thing")
            }
        }
    }
}

#Preview {
    DictionaryView()
}
