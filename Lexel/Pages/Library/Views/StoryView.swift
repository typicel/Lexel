//
//  VocabParagraph.swift
//  Lexel
//
//  Created by enzo on 5/24/24.
//

import SwiftUI
import SwiftData
import AVFoundation
import NaturalLanguage
import Translation

struct StoryView: View {
    @EnvironmentObject var themeService: ThemeService
    @State private var viewModel: StoryViewModel
    
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
                        ForEach(viewModel.tokens, id: \.self) { token in
                            Text(token.value!)
                                .onTapGesture {
                                    Task {
                                        await viewModel.handleTapGesture(for: token)
                                    }
                                }
                        }
                    }
                    Spacer()
                }
                .frame(width: geo.size.width * 0.8)
                .background(themeService.selectedTheme.readerColor)
                .toolbar {
                    ReaderToolbar()
                }
            }
            .environmentObject(self.themeService)
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
                    //                    Picker("Font Style", selection: self.$selectedFont) {
                    //                        ForEach(Constants.fontStyles.enumeratedArray(), id: \.offset) { offset, font in
                    //                            Text(font.name).tag(offset)
                    //                        }
                    //                    }
                    //                    .pickerStyle(.automatic)
                    //                    .onChange(of: self.selectedFont) {
                    //                        self.themeService.setFont(Constants.fontStyles[self.selectedFont])
                    //                    }
                    
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
