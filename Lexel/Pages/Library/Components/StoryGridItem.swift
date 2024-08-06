//
//  StoryListView.swift
//  Lexel
//
//  Created by Tyler McCormick on 6/25/24.
//

import SwiftUI

struct StoryGridItem: View {
    let story: Story
    
    let displayName: [String:String] = [
        "de-DE": "Deutsch",
        "en-US": "English",
        "es-ES": "Spanish",
        "fr-FR": "French",
        "ko-KR": "Korean",
        "ja-JP": "Japanese",
        "zh-CN": "Chinese"
    ]
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.white.opacity(0.5))
            
            VStack(alignment: .leading) {
                Text(story.title!)
                    .font(.title)
                Text(displayName[story.language!] ?? "???")
            }
            .padding()
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .frame(height: 200)
    }
}

