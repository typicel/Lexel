//
//  MigrationPlan.swift
//  Lexel
//
//  Created by enzo on 6/8/24.
//

import Foundation
import SwiftData


enum LexelMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [LexelSchemaV1.self]
    }
    
    static var stages: [MigrationStage] {
        []
    }
}
