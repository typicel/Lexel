//
//  LibraryView.swift
//  Lexel
//
//  Created by enzo on 5/24/24.
//

import SwiftUI
import NaturalLanguage
import SwiftData
import OSLog

struct LibraryView: View {
    @Namespace private var animation
    @StateObject private var viewModel = LibraryViewModel()
    
    let rows = [
        GridItem(.flexible(), spacing: 30),
        GridItem(.flexible(), spacing: 30),
        GridItem(.flexible(), spacing: 30)
    ]
    
    var body: some View {
        NavigationStack {
            if viewModel.stories.isEmpty {
                ContentUnavailableView("No Stories", systemImage: "books.vertical", description: Text("Add stories to start learning"))
            } else {
                ScrollView {
                    LazyVGrid(columns: rows, alignment: .center, spacing: 30) {
                        ForEach(viewModel.stories, id: \.self) { story in
                            NavigationLink(value: story) {
                                StoryGridItem(story: story)
                                    .matchedTransitionSource(id: story.id, in: animation)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                    .navigationDestination(for: Story.self) { story in
                        StoryView(story: story, namespace: animation)
                            .navigationTransition(
                                .zoom(sourceID: story.id, in: animation)
                            )
                    }
                }
                .sheet(isPresented: $viewModel.isShowingAddStorySheet) { AddStoryView() }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("New", systemImage: "plus") {
                            viewModel.showSheet()
                        }
                    }
                }
            }
        }
    }
}

func relativeTimeString(for date: Date) -> String {
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .full
    var string = formatter.localizedString(for: date, relativeTo: Date())
    if string == "in 0 seconds" {
        string = "Just now"
    }
    
    return string
}

#Preview {
    LibraryView()
}

