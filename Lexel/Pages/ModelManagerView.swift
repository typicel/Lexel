//
//  ModelManagerView.swift
//  Lexel
//
//  Created by Tyler McCormick on 6/11/24.
//

import SwiftUI

let smallToBigMap: Dictionary<String, String> = [
    "de": "German",
    "en": "English",
    "ko": "Korean",
    "ja": "Japanese",
    "fr": "French",
    "es": "Spanish"
]

struct ModelManagerView: View {
    
    @EnvironmentObject var modelManager: MLModelManager
    @Environment(\.dismiss) var dismiss
    
    @State private var isShowingChoiceSheet = false
    @State private var progress: Progress? = nil
    @State private var downloading: Int? = nil
    @State private var ping: Timer? = nil
    
    var body: some View {
        VStack {
            List(Constants.allowedLanguages.enumeratedArray(), id: \.offset) { offset, lang in
                HStack {
                    if !modelManager.isDownloaded(lang: lang.mlLanguage) {
                        if let progress = progress, !progress.isFinished {
                            ProgressView()
                        } else {
                            Button {
                                self.progress = modelManager.downloadModel(for: lang.mlLanguage)
                                self.downloading = offset
                                self.startPing()
                            } label: {
                                Image(systemName: "plus.circle")
                            }
                        }
                    }
                    
                    Text(lang.displayName)
                }
                .swipeActions {
                    Button("Delete") {
                        modelManager.deleteModel(for: lang.mlLanguage)
                    }
                    .tint(.red)
                }
            }
        }
        .onChange(of: self.progress) {
            if let progress = self.progress {
                print(progress.isFinished)
                print(progress.completedUnitCount)
            }
        }
    }
    
    private func startPing() {
        self.ping?.invalidate()
        
        self.ping = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if progress?.isFinished == true {
                self.progress = nil
                self.downloading = nil
                self.ping?.invalidate()
            }
        }
    }
    
}

#Preview {
    ModelManagerView()
        .environmentObject(MLModelManager())
}
