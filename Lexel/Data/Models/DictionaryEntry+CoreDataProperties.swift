//
//  DictionaryEntry+CoreDataProperties.swift
//  Lexel
//
//  Created by Tyler McCormick on 8/4/24.
//
//

import Foundation
import CoreData


extension DictionaryEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DictionaryEntry> {
        return NSFetchRequest<DictionaryEntry>(entityName: "DictionaryEntry")
    }

    @NSManaged public var definition: String?
    @NSManaged public var familiarity: Int16
    @NSManaged public var id: UUID?
    @NSManaged public var word: String?
    @NSManaged public var parent: DictionaryEntry?

}

extension DictionaryEntry : Identifiable {

}
