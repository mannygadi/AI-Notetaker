//
//  NoteTypeFilterRow.swift
//  AI Notetaker
//
//  Created by Claude on 11/27/25.
//

import SwiftUI

struct NoteTypeFilterRow: View {
    let noteType: NoteType
    let isSelected: Bool
    let onAddNote: () -> Void

    var body: some View {
        Button(action: onAddNote) {
            HStack {
                Image(systemName: noteType.systemImage)
                    .foregroundColor(noteType.systemImageColor)
                    .font(.title2)

                Text(noteType.displayName)
                        .font(.headline)
                Spacer()
            }
        }
        .tint(isSelected ? .accentColor : .primary)
        .contentShape(RoundedRectangle(cornerRadius: 8))
    }
}