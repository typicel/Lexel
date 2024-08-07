//
//  VocabParagraph.swift
//  Lexel
//
//  Created by enzo on 5/24/24.
//

import SwiftUI
import SwiftData

struct StoryView: View {
    @ObservedObject var themeService: ThemeService = ThemeService.shared
    @EnvironmentObject var library: LibraryViewModel
    @ObservedObject var viewModel: StoryViewModel
    
    @State private var showingPopover: Bool = false
    
    init(story: Story) {
        viewModel = StoryViewModel(story: story)
        viewModel.fetchTokens()
    }
    
    var body: some View {
        HStack {
            ScrollView(showsIndicators: false) {
                Text(viewModel.story.title)
                    .font(themeService.selectedFont.readerFontWithSize(36))
                    .foregroundColor(themeService.selectedTheme.textColor)
                
                FlowView(.vertical, alignment: .leading, horizontalSpacing: 0) {
                    ForEach(viewModel.story.typedTokens, id: \.self) { token in
                        Text(token.value)
                            .foregroundColor(themeService.selectedTheme.textColor)
                            .scaledFont(name: themeService.selectedFont.name, size: themeService.fontSize)
                            .onTapGesture {
                                Task {
                                    await viewModel.handleTapGesture(for: token)
                                }
                            }
                            .background(viewModel.backgroundColor(for: token))
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(themeService.selectedTheme.readerColor)
            
            FamiliarWordView()
                .environmentObject(viewModel)
                .frame(maxWidth: 400)
        }
        .toolbar {
            ReaderToolbar()
        }
        .onReceive(library.$selectedStory, perform: { story in
            if let story = story {
                viewModel.updateStory(with: story)
            }
        })
    }
}

struct ReaderToolbar: ToolbarContent {
    @ObservedObject var themeService: ThemeService = ThemeService.shared
    
    // MARK: Figure out how to set selectedFont on init
    @State private var selectedFont: Int = 0
    @State private var showSettingsPopover: Bool = false
    
    var body: some ToolbarContent {
        
        ToolbarItemGroup(placement: .primaryAction) {
            Button {
                showSettingsPopover = true
            } label: {
                Image(systemName: "textformat")
            }
            .popover(isPresented: $showSettingsPopover) {
                List {
                    Picker(selection: $selectedFont, label: Text("Font")) {
                        Text("Sans-Serif").tag(0)
                        Text("Serif").tag(1)
                        Text("Atkinson").tag(2)
                    }
                    .onChange(of: selectedFont) { oldValue, newValue in
                        themeService.setFont(Constants.fontStyles[newValue])
                    }
                    
                    HStack(alignment: .firstTextBaseline) {
                        Button {
                            themeService.setFontSize(ThemeService.shared.fontSize - 1)
                        } label: {
                            Image(systemName: "character")
                                .font(.title2)
                        }
                        
                        Button {
                            themeService.setFontSize(ThemeService.shared.fontSize + 1)
                        } label: {
                            Image(systemName: "character")
                                .font(.title)
                        }
                    }
                    
                    HStack {
                        ForEach(Constants.themes.enumeratedArray(), id: \.offset) { offset, theme in
                            Circle()
                                .stroke(theme.name == themeService.selectedTheme.name ? Color.blue : Color.gray, lineWidth: theme.name == themeService.selectedTheme.name ? 4 : 2)
                                .fill(theme.readerColor)
                                .frame(width: 30, height: 30)
                                .onTapGesture {
                                    themeService.setTheme(theme)
                                }
                        }
                    }
                }
                .padding()
            }
        }
    }
}


//#Preview {
//    MainActor.assumeIsolated {
//        StoryView()
//    }
//}
