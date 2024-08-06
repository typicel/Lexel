//
//  VocabParagraph.swift
//  Lexel
//
//  Created by enzo on 5/24/24.
//

import SwiftUI
import SwiftData
import NaturalLanguage

@available(iOS 13, macCatalyst 13, tvOS 13, watchOS 6, *)
struct ScaledFont: ViewModifier {
    @Environment(\.sizeCategory) var sizeCategory
    var name: String
    var size: Double
    
    func body(content: Content) -> some View {
        let scaledSize = UIFontMetrics.default.scaledValue(for: size)
        switch name {
        case "New York":
            return content.font(.system(size: scaledSize, design: .serif))
        case "San Francisco":
            return content.font(.system(size: scaledSize, design: .default))
        default:
            return content.font(.custom(name, size: scaledSize))
        }
    }
}

@available(iOS 13, macCatalyst 13, tvOS 13, watchOS 6, *)
extension View {
    func scaledFont(name: String, size: Double) -> some View {
        return self.modifier(ScaledFont(name: name, size: size))
    }
}

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
                Text(viewModel.story.title!)
                    .font(themeService.selectedFont.readerFontWithSize(36))
                    .foregroundColor(themeService.selectedTheme.textColor)
                
                FlowView(.vertical, alignment: .leading, horizontalSpacing: 0) {
                    ForEach(viewModel.story.typedTokens, id: \.self) { token in
                        Text(token.value!)
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
            
            if let def = viewModel.translatedWord {
                FamiliarWordView(token: viewModel.selectedWord!, language: viewModel.story.language!, definition: def)
                    .frame(maxWidth: 400)
            } else {
                Text("")
                    .frame(width: 400)
            }
        }
        .toolbar {
            ReaderToolbar()
        }
        .onChange(of: library.selectedStory!) { oldValue, newValue in
            viewModel.updateStory(with: newValue)
        }
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
