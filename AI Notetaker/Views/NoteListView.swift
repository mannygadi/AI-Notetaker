//
//  NoteListView.swift
//  AI Notetaker
//
//  Created by Claude on 11/27/25.
//

import SwiftUI
import CoreData

struct NoteListView: View {
    let notes: [Note]
    let selectedFilter: NoteType?
    @Binding var searchText: String
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        VStack(spacing: 0) {
            // Search bar
            if selectedFilter == nil || !searchText.isEmpty {
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                    .padding(.bottom, 8)
            }

            // Notes list
            List {
                ForEach(notes) { note in
                    NavigationLink(destination: NoteDetailView(note: note)) {
                        NoteRowView(note: note)
                    }
                    .contextMenu {
                        NoteContextMenu(note: note)
                    }
                }
                .onDelete(perform: deleteNotes)
            }
        }
        .overlay {
            if notes.isEmpty && !searchText.isEmpty {
                ContentUnavailableView.search(text: searchText)
            } else if notes.isEmpty {
                ContentUnavailableView {
                    Label("No Notes", systemImage: "note.text")
                } description: {
                    if let filter = selectedFilter {
                        Text("No \(filter.displayName.lowercased()) notes found")
                    } else {
                        Text("Create your first note to get started")
                    }
                } actions: {
                    Button("Add Note") {
                        // Add note functionality
                    }
                }
            }
        }
        .navigationTitle(navigationTitle)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    ForEach(NoteType.allCases) { noteType in
                        Button {
                            addNote(of: noteType)
                        } label: {
                            Label("Add \(noteType.displayName)", systemImage: noteType.systemImage)
                        }
                    }
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }

    private var navigationTitle: String {
        if let filter = selectedFilter {
            return filter.displayName
        }
        return "All Notes"
    }

    private func deleteNotes(offsets: IndexSet) {
        withAnimation {
            offsets.map { notes[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                // Replace with proper error handling
                print("Error saving context: \(nsError)")
            }
        }
    }

    private func addNote(of type: NoteType) {
        withAnimation {
            let newNote = Note(context: viewContext, type: type)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                // Replace with proper error handling
                print("Error saving context: \(nsError)")
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)

            TextField("Search notes...", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

struct NoteContextMenu: View {
    let note: Note
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        Button {
            deleteNote()
        } label: {
            Label("Delete", systemImage: "trash")
        }
    }

    private func deleteNote() {
        withAnimation {
            viewContext.delete(note)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                // Replace with proper error handling
                print("Error saving context: \(nsError)")
            }
        }
    }
}