//
//  VocabParagraph.swift
//  Lexel
//
//  Created by enzo on 5/24/24.
//

import SwiftUI
import SwiftData
import NaturalLanguage

struct StoryView: View {
    @EnvironmentObject var themeService: ThemeService
    @EnvironmentObject var library: LibraryViewModel
    @ObservedObject var viewModel: StoryViewModel

    init(story: Story) {
        viewModel = StoryViewModel(story: story)
        viewModel.fetchTokens()
    }
    
    var body: some View {
        GeometryReader { geo in
            HStack {
                Spacer()
                ScrollView(showsIndicators: false) {
                    Text(viewModel.story.title!)
                        .font(themeService.selectedFont.readerFont(with: 36))
                        .foregroundColor(themeService.selectedTheme.textColor)
                    
                    FlowView(.vertical, alignment: .leading, horizontalSpacing: 0) {
                        ForEach(viewModel.story.typedTokens, id: \.self) { token in
                            Text(token.value!)
                                .foregroundColor(themeService.selectedTheme.textColor)
                                .font(.title)
                                .onTapGesture {
                                    Task {
                                        await viewModel.handleTapGesture(for: token)
                                    }
                                }
                                .background(viewModel.backgroundColor(for: token))
                        }
                    }
                }
                .frame(width: geo.size.width * 0.8)
                
                Spacer()
            }
            .background(themeService.selectedTheme.readerColor)
            .toolbar {
                ReaderToolbar()
            }
            .environmentObject(self.themeService)
            .onChange(of: library.selectedStory!) { oldValue, newValue in
                viewModel.updateStory(with: newValue)
            }
        }
    }
}

struct ReaderToolbar: ToolbarContent {
    @EnvironmentObject var themeService: ThemeService
    
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
                VStack {
                    HStack {
                        ForEach(Constants.themes.enumeratedArray(), id: \.offset) { offset, theme in
                            Circle()
                                .stroke(theme.name == self.themeService.selectedTheme.name ? Color.blue : Color.gray, lineWidth: theme.name == self.themeService.selectedTheme.name ? 4 : 2)
                                .fill(theme.readerColor)
                                .frame(width: 30, height: 30)
                                .onTapGesture {
                                    self.themeService.setTheme(theme)
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
