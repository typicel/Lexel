//
//  Token+CoreDataProperties.swift
//  Lexel
//
//  Created by Tyler McCormick on 8/4/24.
//
//

import Foundation
import CoreData


extension Token {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Token> {
        return NSFetchRequest<Token>(entityName: "Token")
    }

    @NSManaged public var id: UUID
    @NSManaged public var length: Int64
    @NSManaged public var position: Int64
    @NSManaged public var startIndex: Int64
    @NSManaged public var value: String
    @NSManaged public var dictionaryEntry: DictionaryEntry?
    @NSManaged public var story: Story
    @NSManaged public var tappable: Bool

}

extension Token : Identifiable {

}
