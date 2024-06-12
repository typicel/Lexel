//
//  MLModelManager.swift
//  Lexel
//
//  Created by Tyler McCormick on 6/11/24.
//

import Foundation
import MLKit

class MLModelManager: ObservableObject {
    @Published var downloadedModels: Array<TranslateRemoteModel>
    
    init() {
        self.downloadedModels = Array(ModelManager.modelManager().downloadedTranslateModels)
    }
    
    func downloadModel(for lang: TranslateLanguage) -> Progress {
        let model = TranslateRemoteModel.translateRemoteModel(language: lang)
        let progress = ModelManager.modelManager().download(
            model,
            conditions: ModelDownloadConditions(
                allowsCellularAccess: false, allowsBackgroundDownloading: true)
            )
        
        
        self.downloadedModels.append(model)
        return progress
    }
    
    func deleteModel(for lang: TranslateLanguage) {
        let model = TranslateRemoteModel.translateRemoteModel(language: lang)
        ModelManager.modelManager().deleteDownloadedModel(model) { error in
            guard error == nil else { return }
           
            self.downloadedModels = self.downloadedModels.filter { $0 != model}
        }
    }
    
    func isDownloaded(lang: TranslateLanguage) -> Bool {
        let downloadedModels = ModelManager.modelManager().downloadedTranslateModels
        let model = TranslateRemoteModel.translateRemoteModel(language: lang)
        
        return downloadedModels.contains(model)
    }
    
    func getDownloadedModels() -> Array<TranslateRemoteModel> {
        return Array(ModelManager.modelManager().downloadedTranslateModels)
    }
}
