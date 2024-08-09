//
//  LexelApp.swift
//  Lexel
//
//  Created by enzo on 5/24/24.
//

import SwiftUI
import SwiftData

@main
struct LexelApp: App {
    @StateObject private var dataManager = DataManager(type: .normal)
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataManager)
                .environment(\.font, Font.custom("AtkinsonHyperlegible-Regular", size: 14))
        }
        .environmentObject(MLModelManager())
    }
}
