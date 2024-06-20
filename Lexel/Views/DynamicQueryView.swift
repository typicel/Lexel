//
//  DynamicQueryView.swift
//  Lexel
//
//  Created by Tyler McCormick on 6/18/24.
//

import Foundation
import SwiftUI
import SwiftData

//public struct DynamicQueryView<T: PersistentModel, Content: View>: View {
//    @Query var query: [T]
//    
//    let content: ([T]) -> Content
//    
//    public var body: some View {
//        self.content(query)
//    }
//    
//    init(descriptor: FetchDescriptor<T>, @ViewBuilder content: @escaping ( [T] ) -> Content) {
//        _query = Query(descriptor)
//        self.content = content
//    }
//}
//
//extension DynamicQueryView where T : VocabWord {
//    init(filterByWord searchWord: String, @ViewBuilder content: @escaping (FetchedResults<T>) -> Content) {
//        let filter = #Predicate<T> { $0.word == searchWord }
//        let sort = [SortDescriptor(\VocabWord.word)]
//        self.init( FetchDescriptor( predicate: filter, sortBy: sort) )
//    }
//}
