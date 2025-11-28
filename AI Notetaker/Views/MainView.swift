//
//  MainView.swift
//  AI Notetaker
//
//  Created by Claude on 11/27/25.
//

import SwiftUI

struct MainView: View {
    @Environment(\.managedObjectContext) private var viewContext

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

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Note type action rows matching MainScreen.PNG
                    VStack(spacing: 0) {
                        MainScreenRow(
                            title: "Record Audio",
                            icon: "mic.fill",
                            iconColor: .red,
                            backgroundColor: Color(red: 1.0, green: 0.9, blue: 0.9),
                            action: {
                                showingAudioRecording = true
                            }
                        )

                        Divider()
                            .padding(.leading, 52)

                        MainScreenRow(
                            title: "Audio File",
                            icon: "waveform",
                            iconColor: .orange,
                            backgroundColor: Color(red: 1.0, green: 0.95, blue: 0.85),
                            action: {
                                // TODO: Implement audio file upload
                            }
                        )

                        Divider()
                            .padding(.leading, 52)

                        MainScreenRow(
                            title: "PDF & Text File",
                            icon: "doc.fill",
                            iconColor: .blue,
                            backgroundColor: Color(red: 0.9, green: 0.95, blue: 1.0),
                            action: {
                                // TODO: Implement PDF/file upload
                            }
                        )

                        Divider()
                            .padding(.leading, 52)

                        MainScreenRow(
                            title: "Input Text",
                            icon: "keyboard",
                            iconColor: .green,
                            backgroundColor: Color(red: 0.9, green: 1.0, blue: 0.9),
                            action: {
                                showingTextNote = true
                            }
                        )

                        Divider()
                            .padding(.leading, 52)

                        MainScreenRow(
                            title: "Web Link",
                            icon: "globe",
                            iconColor: .purple,
                            backgroundColor: Color(red: 0.95, green: 0.9, blue: 1.0),
                            action: {
                                // TODO: Implement web link
                            }
                        )
                    }
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                    .padding(.horizontal)

                    // Recent notes section
                    if !notes.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Recent Notes")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .padding(.horizontal)

                            VStack(spacing: 0) {
                                ForEach(Array(notes.prefix(5)), id: \.id) { note in
                                    NavigationLink(destination: NoteDetailView(note: note)) {
                                        NoteRowView(note: note)
                                    }
                                    .buttonStyle(PlainButtonStyle())

                                    if note.id != notes.first?.id {
                                        Divider()
                                            .padding(.leading, 16)
                                    }
                                }
                            }
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.top, 16)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Notes")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAudioRecording = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
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
}