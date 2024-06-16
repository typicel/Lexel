//
//  ShareViewController.swift
//  Lexel-ShareExtension
//
//  Created by Tyler McCormick on 6/12/24.
//

import UIKit
import UniformTypeIdentifiers
import SwiftUI
import SwiftData

@objc(ShareViewController)
class ShareViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let contentView
        
//        guard
//            let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
//            let itemProvider = extensionItem.attachments?.first else { return }
//        
//        let textDataType = UTType.plainText.identifier
//        if itemProvider.hasItemConformingToTypeIdentifier(textDataType) {
//            
//            itemProvider.loadItem(forTypeIdentifier: textDataType, options: nil) { (providedText, error) in
//                if let error {
//                    self.close()
//                    return
//                }
//                
//                if let text = providedText as? String {
//                    
//                    let contentView = UIHostingController(rootView: AddStoryView(text: text).modelContext(ConfigureModelContainer()))
                    let contentView = UIHostingController(rootView: Text("Hello world!"))
                    self.addChild(contentView)
                    self.view.addSubview(contentView.view)
                    
                    // set up constraints
                    contentView.view.translatesAutoresizingMaskIntoConstraints = false
                    contentView.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
                    contentView.view.bottomAnchor.constraint (equalTo: self.view.bottomAnchor).isActive = true
                    contentView.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
                    contentView.view.rightAnchor.constraint (equalTo: self.view.rightAnchor).isActive = true
//                    
//                } else {
//                    self.close()
//                    return
//                }
//            }
//            
//        } else {
//            self.close()
//            return
//        }
        
    }
    
    func close() {
        self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
}
