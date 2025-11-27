//
//  NoteType.swift
//  AI Notetaker
//
//  Created by Claude on 11/27/25.
//

import Foundation

enum NoteType: String, CaseIterable, Identifiable {
    case audio = "audio"
    case text = "text"
    case pdf = "pdf"
    case webLink = "webLink"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .audio:
            return "Audio"
        case .text:
            return "Text"
        case .pdf:
            return "PDF"
        case .webLink:
            return "Web Link"
        }
    }

    var systemImage: String {
        switch self {
        case .audio:
            return "mic.fill"
        case .text:
            return "text.alignleft"
        case .pdf:
            return "doc.fill"
        case .webLink:
            return "link"
        }
    }
}