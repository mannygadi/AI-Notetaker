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

    // Collapsible UI state
    @State private var showingSelectionRows = true
    @State private var selectionRowsOffset: CGFloat = 0
    @State private var lastPanValue: CGFloat = 0

    // Filter and folder state
    @State private var selectedFilter: NoteFilterType = .all
    @State private var selectedFolder: String = "Default"

    // Fetch request for all notes
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Note.timestamp, ascending: false)],
        animation: .default)
    private var notes: FetchedResults<Note>

    // Computed filtered notes based on selected filter
    private var filteredNotes: [Note] {
        switch selectedFilter {
        case .all:
            return Array(notes)
        case .audio:
            return notes.filter { $0.noteTypeEnum == .audio }
        case .document:
            return notes.filter { $0.noteTypeEnum == .pdf }
        case .link:
            return notes.filter { $0.noteTypeEnum == .webLink }
        }
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                // Main content
                NavigationStack {
                    ScrollView {
                        VStack(spacing: 16) {
                            // Filter header with folder selection and tabs
                            FilterHeaderTabs(
                                selectedFilter: $selectedFilter,
                                selectedFolder: $selectedFolder,
                                notes: Array(notes)
                            )

                            // Filtered notes section
                            if !filteredNotes.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("All Notes")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .padding(.horizontal)

                                    VStack(spacing: 0) {
                                        ForEach(filteredNotes, id: \.id) { note in
                                            NavigationLink(destination: NoteDetailView(note: note)) {
                                                NoteRowView(note: note)
                                            }
                                            .buttonStyle(PlainButtonStyle())

                                            if note.id != filteredNotes.last?.id {
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

                            // Spacer for bottom content
                            Spacer()
                                .frame(height: 80) // Space for floating button
                        }
                        .padding(.top, 16)
                    }
                    .background(Color(.systemGroupedBackground))
                    .navigationTitle("Notes")
                    .navigationBarTitleDisplayMode(.large)
                    // No toolbar + button anymore
                }

                // Collapsible selection rows overlay
                if showingSelectionRows {
                    VStack(spacing: 0) {
                        Spacer()

                        // Semi-transparent overlay
                        Color.black.opacity(0.3)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    showingSelectionRows = false
                                    selectionRowsOffset = 0
                                }
                            }

                        // Scroll indicator at top center
                        HStack {
                            Spacer()
                            VStack(spacing: 4) {
                                RoundedRectangle(cornerRadius: 2.5)
                                    .fill(Color.gray.opacity(0.6))
                                    .frame(width: 36, height: 5)

                                Text("Scroll for options")
                                    .font(.caption)
                                    .foregroundColor(.gray.opacity(0.8))
                            }
                            .padding(.top, 8)
                            .padding(.horizontal, 20)
                            Spacer()
                        }

                        // Selection rows as separate slots
                        VStack(spacing: 12) {
                            MainScreenRow(
                                title: "Record Audio",
                                icon: "mic.fill",
                                iconColor: .red,
                                backgroundColor: Color(red: 1.0, green: 0.9, blue: 0.9),
                                action: {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        showingSelectionRows = false
                                    }
                                    showingAudioRecording = true
                                }
                            )

                            MainScreenRow(
                                title: "Audio File",
                                icon: "waveform",
                                iconColor: .orange,
                                backgroundColor: Color(red: 1.0, green: 0.95, blue: 0.85),
                                action: {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        showingSelectionRows = false
                                    }
                                    // TODO: Implement audio file upload
                                }
                            )

                            MainScreenRow(
                                title: "PDF & Text File",
                                icon: "doc.fill",
                                iconColor: .blue,
                                backgroundColor: Color(red: 0.9, green: 0.95, blue: 1.0),
                                action: {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        showingSelectionRows = false
                                    }
                                    // TODO: Implement PDF/file upload
                                }
                            )

                            MainScreenRow(
                                title: "Input Text",
                                icon: "keyboard",
                                iconColor: .green,
                                backgroundColor: Color(red: 0.9, green: 1.0, blue: 0.9),
                                action: {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        showingSelectionRows = false
                                    }
                                    showingTextNote = true
                                }
                            )

                            MainScreenRow(
                                title: "Web Link",
                                icon: "globe",
                                iconColor: .purple,
                                backgroundColor: Color(red: 0.95, green: 0.9, blue: 1.0),
                                action: {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        showingSelectionRows = false
                                    }
                                    // TODO: Implement web link
                                }
                            )
                        }
                        .background(Color.white)
                        .cornerRadius(20, corners: [.topLeft, .topRight])
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: -5)
                        .offset(y: selectionRowsOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let delta = value.translation.height - lastPanValue
                                    if delta > 0 { // Only allow dragging down
                                        selectionRowsOffset = min(delta, 200)
                                    }
                                    lastPanValue = value.translation.height
                                }
                                .onEnded { value in
                                    let threshold: CGFloat = 100
                                    if selectionRowsOffset > threshold {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            showingSelectionRows = false
                                            selectionRowsOffset = geometry.size.height
                                        }
                                    } else {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            selectionRowsOffset = 0
                                        }
                                    }
                                    lastPanValue = 0
                                }
                        )
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                // Blue + New Note button (only when selection rows are hidden)
                if !showingSelectionRows {
                    VStack {
                        Spacer()

                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showingSelectionRows = true
                                selectionRowsOffset = 0
                            }
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "plus")
                                    .font(.system(size: 16, weight: .semibold))

                                Text("New Note")
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 16)
                            .background(Color.blue)
                            .cornerRadius(28)
                            .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40) // Safe area
                    }
                }
            }
        }
        .ignoresSafeArea(.keyboard)
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

// Extension for custom corner radius
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}