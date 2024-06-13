//
//  LibraryView.swift
//  Lexel
//
//  Created by enzo on 5/24/24.
//

import SwiftUI
import NaturalLanguage
import SwiftData

struct LibraryView: View {
    
    @Environment(\.modelContext) private var context
    
    @State private var selectedStoryIdx: Int? = 1
    @State private var isShowingAddStorySheet: Bool = false
    @State private var isShowingEditStorySheet: Bool = false
    @State private var editingStory: Story? = nil
    @State private var showModelSheet: Bool = false
    
    private let modelManager = MLModelManager()
    
    @Query private var stories: [Story]
    
    private func showSheet() { isShowingAddStorySheet = true }
    private func deleteItem(_ item: Story) { context.delete(item) }
    private func editItem(_ item: Story) { self.editingStory = item }
    private func reset() { self.editingStory = nil }
    
    var body: some View {
        NavigationSplitView {
            VStack {
                List {
                    ForEach(stories.enumeratedArray(), id: \.offset) { offset, element in
                        NavigationLink(value: offset) {
                            StoryListView(element: element)
                        }
                        .swipeActions(allowsFullSwipe: false) {
                            
                            Button(role: .destructive) {
                                context.delete(element)
                            } label: {
                                Label("Delete Story", systemImage: "trash")
                            }
                            .tint(.red)
                            
                            Button {
                                editingStory = element
                                isShowingEditStorySheet = true
                            } label: {
                                Label("Edit Story", systemImage: "pencil")
                            }
                            .tint(.indigo)
                            
                        }
                    }
                    .onDelete { indexes in
                        for index in indexes {
                            deleteItem(stories[index])
                        }
                    }
                    
                }
                .navigationDestination(for: Int.self) {
                    VocabParagraph(story: stories[$0])
                }
                .navigationTitle("Lexel")
                .listStyle(.inset)
                
                Spacer()
                
                Button(action: showSheet) {
                    Label("Add Story", systemImage: "plus.circle")
                }
                
//                Button {
//                    showModelSheet = true
//                } label: {
//                    Label("Manage Models", systemImage: "slider.vertical.3")
//                }
                
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
                ForEach(modelManager.getDownloadedModels(), id: \.self) { model in
                    Text(model.language.rawValue)
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
        .sheet(isPresented: $showModelSheet) {
            ModelManagerView()
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
    let element: Story
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .firstTextBaseline) {
                Text(element.title)
                    .font(.title3)
                    .bold()
                
                Text(element.language.shortName)
                    .font(.caption)
            }
            if let date = element.lastOpened {
                Text("\(relativeTimeString(for: date))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}
