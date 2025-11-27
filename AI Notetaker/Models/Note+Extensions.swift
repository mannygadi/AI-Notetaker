//
//  Note+Extensions.swift
//  AI Notetaker
//
//  Created by Claude on 11/27/25.
//

import Foundation
import CoreData

extension Note {
    var noteTypeEnum: NoteType {
        get {
            return NoteType(rawValue: noteType ?? "text") ?? .text
        }
        set {
            noteType = newValue.rawValue
        }
    }

    convenience init(context: NSManagedObjectContext, type: NoteType, title: String? = nil) {
        self.init(context: context)
        self.id = UUID()
        self.noteType = type.rawValue
        self.timestamp = Date()
        self.title = title ?? "New \(type.displayName) Note"
        self.duration = 0.0
    }
}