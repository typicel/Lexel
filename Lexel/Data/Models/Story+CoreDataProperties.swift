//
//  Story+CoreDataProperties.swift
//  Lexel
//
//  Created by Tyler McCormick on 8/4/24.
//
//

import Foundation
import CoreData


extension Story {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Story> {
        return NSFetchRequest<Story>(entityName: "Story")
    }

    @NSManaged public var id: UUID
    @NSManaged public var language: String
    @NSManaged public var lastOpened: Date
    @NSManaged public var rawText: String
    @NSManaged public var title: String
    @NSManaged public var tokens: NSOrderedSet

}

// MARK: Generated accessors for tokens
extension Story {

    @objc(insertObject:inTokensAtIndex:)
    @NSManaged public func insertIntoTokens(_ value: Token, at idx: Int)

    @objc(removeObjectFromTokensAtIndex:)
    @NSManaged public func removeFromTokens(at idx: Int)

    @objc(insertTokens:atIndexes:)
    @NSManaged public func insertIntoTokens(_ values: [Token], at indexes: NSIndexSet)

    @objc(removeTokensAtIndexes:)
    @NSManaged public func removeFromTokens(at indexes: NSIndexSet)

    @objc(replaceObjectInTokensAtIndex:withObject:)
    @NSManaged public func replaceTokens(at idx: Int, with value: Token)

    @objc(replaceTokensAtIndexes:withTokens:)
    @NSManaged public func replaceTokens(at indexes: NSIndexSet, with values: [Token])

    @objc(addTokensObject:)
    @NSManaged public func addToTokens(_ value: Token)

    @objc(removeTokensObject:)
    @NSManaged public func removeFromTokens(_ value: Token)

    @objc(addTokens:)
    @NSManaged public func addToTokens(_ values: NSOrderedSet)

    @objc(removeTokens:)
    @NSManaged public func removeFromTokens(_ values: NSOrderedSet)

}

extension Story : Identifiable {

}
