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
    @StateObject private var viewModel = LibraryViewModel()
    
    var body: some View {
        NavigationSplitView {
            VStack {
                List(selection: $viewModel.selectedStory) {
                    
                    ForEach(viewModel.stories, id: \.self) { story in
                        NavigationLink(value: story) {
                            StoryListView(story: story)
                        }
                        .swipeActions(allowsFullSwipe: false) {
                            
                            Button(role: .destructive) {
                                do {
//                                    try context.save()
                                } catch {
                                    os_log("Failed to save context: \(error.localizedDescription)")
                                }
                            } label: {
                                Label("Delete Story", systemImage: "trash")
                            }
                            
                            Button {
                                viewModel.editingStory = story
                                viewModel.isShowingEditStorySheet = true
                            } label: {
                                Label("Edit Story", systemImage: "pencil")
                            }
                            .tint(.indigo)
                        }
                    }
//                    .onDelete(perform: deleteItems)
                }
                .accessibilityIdentifier("storyList")
                .listStyle(.inset)
                
                Spacer()
                
                Button(action: viewModel.showSheet) {
                    Label("Add Story", systemImage: "plus.circle")
                }
                .accessibilityIdentifier("addStoryButton")
            }
        } detail: {
            if viewModel.stories.isEmpty {
                ContentUnavailableView(label: {
                    Label("No Stories", systemImage: "book")
                }, description: {
                    Text("Add a story to start learning")
                }, actions: {
                    Button("Add Story") { viewModel.isShowingAddStorySheet = true }
                })
            } else {
                if let story = viewModel.selectedStory {
                    StoryView(story: story)
                        .environmentObject(viewModel)
                } else {
                    Text("Lexel")
                }
            }
        }
        .navigationSplitViewStyle(.balanced)
        .sheet(isPresented: $viewModel.isShowingAddStorySheet) { AddStoryView() }
        .sheet(item: $viewModel.editingStory) {
            viewModel.reset()
        } content: { story in
            EditStoryView()
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

