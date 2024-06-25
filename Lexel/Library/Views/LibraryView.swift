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
    @Environment(\.modelContext) private var context
    
    @State private var selectedStory: Story? = nil
    @State private var isShowingAddStorySheet: Bool = false
    @State private var isShowingEditStorySheet: Bool = false
    @State private var editingStory: Story? = nil
    @State private var showModelSheet: Bool = false
    
//    private let modelManager = MLModelManager()
    
    @Query private var stories: [Story]
    
    private func showSheet() { isShowingAddStorySheet = true }
    private func deleteItem(_ item: Story) { context.delete(item) }
    private func editItem(_ item: Story) { self.editingStory = item }
    private func reset() { self.editingStory = nil }
    
    var body: some View {
        NavigationSplitView {
            VStack {
                List(selection: $selectedStory) {
                    
                    ForEach(stories, id: \.self) { story in
                        NavigationLink(value: story) {
                            StoryListView(story: story)
                        }
                        .swipeActions(allowsFullSwipe: false) {
                            
                            Button(role: .destructive) {
                                do {
                                    try context.save()
                                } catch {
                                    os_log("Failed to save context: \(error.localizedDescription)")
                                }
                            } label: {
                                Label("Delete Story", systemImage: "trash")
                            }
                            
                            Button {
                                editingStory = story
                                isShowingEditStorySheet = true
                            } label: {
                                Label("Edit Story", systemImage: "pencil")
                            }
                            .tint(.indigo)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .accessibilityIdentifier("storyList")
//                .navigationDestination(for: Story.self) { _ in
//                    if let story = selectedStory {
//                        VocabParagraph(story: story)
//                    }
//                }
                .navigationTitle("Lexel")
                .listStyle(.inset)
                
                Spacer()
                
                Button(action: showSheet) {
                    Label("Add Story", systemImage: "plus.circle")
                }
                .accessibilityIdentifier("addStoryButton")
            }
        } detail: {
            if stories.isEmpty {
                ContentUnavailableView(label: {
                    Label("No Stories", systemImage: "book")
                }, description: {
                    Text("Add a story to start learning")
                }, actions: {
                    Button("Add Story") { isShowingAddStorySheet = true }
                })
            } else {
                if let story = selectedStory {
                    VocabParagraph(story: story)
                } else {
                    Text("Welcome to sexel")
                }
            }
        }
        .navigationSplitViewStyle(.balanced)
        .sheet(isPresented: $isShowingAddStorySheet) { AddStoryView() }
        .sheet(item: $editingStory) {
            reset()
        } content: { story in
            EditStoryView(story: story)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                context.delete(stories[index])
            }
            try! context.save()
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
    MainActor.assumeIsolated {
        LibraryView()
            .modelContainer(for: [Story.self, VocabWord.self])
    }
}

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
