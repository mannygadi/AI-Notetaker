//
//  MainView.swift
//  AI Notetaker
//
//  Created by Claude on 11/27/25.
//

import SwiftUI
import CoreData

struct MainView: View {
    @Environment(\.managedObjectContext) private var viewContext

    // Filter state
    @State private var selectedFilter: NoteType? = nil
    @State private var searchText: String = ""

    // Fetch request with filtering
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Note.timestamp, ascending: false)],
        animation: .default
    )
    private var allNotes: FetchedResults<Note>

    private var filteredNotes: [Note] {
        var notes = Array(allNotes)

        // Apply note type filter
        if let filter = selectedFilter {
            notes = notes.filter { $0.noteTypeEnum == filter }
        }

        // Apply search filter
        if !searchText.isEmpty {
            notes = notes.filter { note in
                (note.title?.localizedCaseInsensitiveContains(searchText) ?? false) ||
                (note.content?.localizedCaseInsensitiveContains(searchText) ?? false) ||
                (note.fileName?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }

        return notes
    }

    var body: some View {
        NavigationSplitView {
            // Sidebar with filters
            SidebarView(
                selectedFilter: $selectedFilter,
                notesCount: allNotes.count
            )
                .navigationSplitViewColumnWidth(min: 200, ideal: 250)
        } content: {
            // Note list
            NoteListView(
                notes: filteredNotes,
                selectedFilter: selectedFilter,
                searchText: $searchText
            )
                .navigationSplitViewColumnWidth(min: 300, ideal: 400)
        } detail: {
            // Detail view for selected note
            Text("Select a note to view details")
                .foregroundColor(.secondary)
        }
        .navigationTitle("AI Note Taker")
    }
}