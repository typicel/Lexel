//
//  StoryListView.swift
//  Lexel
//
//  Created by Tyler McCormick on 6/25/24.
//

import SwiftUI

struct StoryListView: View {
    let story: Story
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .firstTextBaseline) {
                Text(story.title)
                    .font(.title3)
                    .bold()
                
                Text(story.language.shortName)
                    .font(.caption)
            }
            if let date = story.lastOpened {
                Text("\(relativeTimeString(for: date))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}
