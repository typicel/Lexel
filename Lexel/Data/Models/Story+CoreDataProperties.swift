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

    @NSManaged public var id: UUID?
    @NSManaged public var language: String?
    @NSManaged public var lastOpened: Date?
    @NSManaged public var rawText: String?
    @NSManaged public var title: String?
    @NSManaged public var tokens: NSSet?

}

// MARK: Generated accessors for tokens
extension Story {

    @objc(addTokensObject:)
    @NSManaged public func addToTokens(_ value: Token)

    @objc(removeTokensObject:)
    @NSManaged public func removeFromTokens(_ value: Token)

    @objc(addTokens:)
    @NSManaged public func addToTokens(_ values: NSSet)

    @objc(removeTokens:)
    @NSManaged public func removeFromTokens(_ values: NSSet)

}

extension Story : Identifiable {

}
