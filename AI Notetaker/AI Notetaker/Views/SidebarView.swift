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

    var body: some View {
        VStack(spacing: 0) {
            // Add new note button at the top
            HStack {
                Spacer()

                Button(action: {
                    onAddNote(.audio)
                }) {
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundColor(.blue)
                }

                Spacer()

                Text("Add New Note")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)

            Divider()
                .padding(.vertical, 4)

            List(selection: $selectedFilter) {
                // "All Notes" filter
                Label {
                    VStack(alignment: .leading) {
                        Text("All Notes")
                            .font(.headline)
                            .foregroundColor(.primary)

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