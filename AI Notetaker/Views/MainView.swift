//
//  MainView.swift
//  AI Notetaker
//
//  Created by Claude on 11/27/25.
//

import SwiftUI

struct MainView: View {
    @Environment(\.managedObjectContext) private var viewContext

    // Filter state
    @State private var selectedFilter: NoteType?
    @State private var searchText: String = ""

    // Sheet presentation states
    @State private var showingAudioRecording = false
    @State private var showingTextNote = false
    @State private var showingFileUpload = false
    @State private var showingWebLink = false

    // Fetch request for all notes
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Note.timestamp, ascending: false)],
        animation: .default)
    private var notes: FetchedResults<Note>

    private var filteredNotes: [Note] {
        if let selectedFilter = selectedFilter {
            return notes.filter { $0.noteTypeEnum == selectedFilter }
        }
        return Array(notes)
    }

    var body: some View {
        NavigationSplitView {
            // Sidebar with filters
            SidebarView(
                selectedFilter: $selectedFilter,
                notesCount: notes.count,
                onAddNote: { noteType in
                    handleAddNote(noteType)
                }
            )
        } detail: {
            // Detail view for selected note
            if let selectedNote = filteredNotes.first {
                NoteDetailView(note: selectedNote)
            } else {
                VStack {
                    Text("No notes found")
                        .font(.title)
                        .foregroundColor(.secondary)

                    Text("Tap the + button to create your first note")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top, 8)
                }
            }
        }
        .sheet(isPresented: $showingAudioRecording) {
            AudioRecordingView()
                .environment(\.managedObjectContext, viewContext)
        }
        .sheet(isPresented: $showingTextNote) {
            TextNoteSheet()
                .environment(\.managedObjectContext, viewContext)
        }
    }

    private func handleAddNote(_ noteType: NoteType) {
        switch noteType {
        case .audio:
            showingAudioRecording = true
        case .text:
            showingTextNote = true
        case .pdf:
            showingFileUpload = true
        case .webLink:
            showingWebLink = true
        }
    }
}