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
    @State private var showingAudioRecording = false

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
            Text("Select a note to View details")
                .foregroundColor(.secondary)
        }
        .navigationTitle("AI Note Taker")
        .audioRecordingSheet(isPresented: $showingAudioRecording) { _ in
            // Recording is handled within the sheet itself
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Menu {
                    ForEach(NoteType.allCases) { noteType in
                        Button {
                            addNewNote(of: noteType)
                        } label: {
                            Label("Add \(noteType.displayName)", systemImage: noteType.systemImage)
                        }
                    }
                } label: {
                    Image(systemName: "plus")
                        .font(.title2)
                }
            }
        }
    }

    private func addNewNote(of type: NoteType) {
        if type == .audio {
            // Show audio recording sheet
            showingAudioRecording = true
        } else {
            // Create other note types directly
            withAnimation {
                let newNote = Note(context: viewContext, type: type, title: "New \(type.displayName) Note")

                do {
                    try viewContext.save()
                } catch {
                    let nsError = error as NSError
                    print("Error saving note: \(nsError)")
                }
            }
        }
    }
}