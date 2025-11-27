//
//  NoteType+Extensions.swift
//  AI Notetaker
//
//  Created by Claude on 11/27/25.
//

import SwiftUI

extension NoteType {
    var systemImageColor: Color {
        switch self {
        case .audio:
            return .red
        case .text:
            return .blue
        case .pdf:
            return .green
        case .webLink:
            return .orange
        }
    }
}