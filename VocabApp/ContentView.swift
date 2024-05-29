//
//  ContentView.swift
//  VocabApp
//
//  Created by enzo on 5/24/24.
//

import SwiftUI
import MLKit



struct ContentView: View {
    
    @State private var selectedStoryIdx: Int? = 1
    let stories = Story.sampleData
    
    var body: some View {
        NavigationSplitView {
            List(stories.enumeratedArray(), id: \.offset) { offset, element in
                NavigationLink(value: offset) {
                    HStack {
                        Text(element.title)
                    }
                }
            }
            .navigationDestination(for: Int.self) {
                VocabParagraph(story: stories[$0])
                    .padding()
            }
            .navigationTitle("Stories")
            .listStyle(.inset)
        } detail: {
        }
        .navigationSplitViewStyle(.prominentDetail)
    }
}

#Preview {
    ContentView()
}
