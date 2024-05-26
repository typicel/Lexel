//
//  ContentView.swift
//  VocabApp
//
//  Created by enzo on 5/24/24.
//

import SwiftUI
import MLKit


struct Story: Identifiable {
    let id: UUID = UUID()
    let title: String
    let text: String
    let language: TranslateLanguage
}

struct ContentView: View {
    
    let story = Story(title: "Freundinnen",  text: "Ricarda ist 21 Jahre alt und wohnt in Lübeck. Lübeck ist eine sehr schöne Stadt im Norden von Deutschland. Ricarda studiert Medizin an der Universität von Lübeck. Sie hat viele Freunde dort.", language: .german)
    
    var body: some View {
        NavigationSplitView {
            Spacer()
            
            Button("Add Story") {
                
            }
            
        } detail: {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                
                VocabParagraph(story: story)
                    .padding()
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
