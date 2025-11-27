//
//  SidebarView.swift
//  AI Notetaker
//
//  Created by Claude on 11/27/25.
//

import SwiftUI

struct SidebarView: View {
    @Binding var selectedFilter: NoteType?
    let notesCount: Int

    var body: some View {
        List(selection: $selectedFilter) {
            // "All Notes" filter
            Label {
                VStack(alignment: .leading) {
                    Text("All Notes")
                    Text("\(notesCount) notes")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            } icon: {
                Image(systemName: "note.text")
                    .foregroundColor(.blue)
            }
            .tag(Optional<NoteType>.none)

            // Divider
            Divider()
                .padding(.vertical, 4)

            // Note type filters
            ForEach(NoteType.allCases) { noteType in
                NoteTypeFilterRow(
                    noteType: noteType,
                    isSelected: selectedFilter == noteType,
                    onAddNote: onAddNote
                )
                .tag(Optional(noteType))
            }
        }
        .listStyle(SidebarListStyle())
        .navigationTitle("Filters")
    }
}

struct NoteTypeFilterRow: View {
    let noteType: NoteType
    let isSelected: Bool

    var body: some View {
        Label {
            HStack {
                Text(noteType.displayName)
                Spacer()
                // Add note count later when implemented
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.accentColor)
                }
            }
        } icon: {
            Image(systemName: noteType.systemImage)
                .foregroundColor(noteType.systemImageColor)
        }
    }
}