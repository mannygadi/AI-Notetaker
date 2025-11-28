//
//  FilterHeaderTabs.swift
//  AI Notetaker
//
//  Created by Claude on 11/27/25.
//

import SwiftUI

struct FilterHeaderTabs: View {
    @Binding var selectedFilter: NoteFilterType
    @Binding var selectedFolder: String
    @Binding var searchText: String
    @State private var showingFolderCreateScreen = false
    let notes: [Note]

    // Folder creation callback
    let onCreateFolder: (String) -> Void

    init(selectedFilter: Binding<NoteFilterType>,
         selectedFolder: Binding<String>,
         searchText: Binding<String>,
         notes: [Note],
         onCreateFolder: @escaping (String) -> Void) {
        self._selectedFilter = selectedFilter
        self._selectedFolder = selectedFolder
        self._searchText = searchText
        self.notes = notes
        self.onCreateFolder = onCreateFolder
    }

    // Computed filtered notes count for each tab
    private var allNotesCount: Int {
        return notes.count
    }

    private var audioNotesCount: Int {
        return notes.filter { $0.noteTypeEnum == .audio }.count
    }

    private var documentNotesCount: Int {
        return notes.filter { $0.noteTypeEnum == .pdf }.count
    }

    private var linkNotesCount: Int {
        return notes.filter { $0.noteTypeEnum == .webLink }.count
    }

    // Computed filtered notes based on filter and search
    private var filteredNotes: [Note] {
        var filtered = notes

        // Apply filter type
        switch selectedFilter {
        case .all:
            break
        case .audio:
            filtered = filtered.filter { $0.noteTypeEnum == .audio }
        case .document:
            filtered = filtered.filter { $0.noteTypeEnum == .pdf }
        case .link:
            filtered = filtered.filter { $0.noteTypeEnum == .webLink }
        }

        // Apply search filter
        if !searchText.isEmpty {
            filtered = filtered.filter { note in
                if let title = note.title?.lowercased() {
                    return title.contains(searchText.lowercased())
                }
                if let content = note.content?.lowercased() {
                    return content.contains(searchText.lowercased())
                }
                return false
            }
        }

        return filtered
    }

    var body: some View {
        VStack(spacing: 0) {
            // Folder selection row
            HStack {
                Button(action: {
                    showingFolderCreateScreen = true
                }) {
                    HStack(spacing: DesignTokens.Spacing.sm) {
                        Image(systemName: "folder")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(DesignTokens.Colors.primary)

                        Text(selectedFolder)
                            .font(DesignTokens.Typography.callout)
                            .foregroundColor(DesignTokens.Colors.primaryText)

                        Image(systemName: "chevron.down")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(DesignTokens.Colors.secondaryText)
                    }
                    .padding(.horizontal, DesignTokens.Spacing.lg)
                    .padding(.vertical, DesignTokens.Spacing.md)
                    .modernSecondaryButton()
                }
                .buttonStyle(.plain)

                Spacer()
            }
            .padding(.horizontal, DesignTokens.Spacing.lg)
            .padding(.top, DesignTokens.Spacing.sm)
            .padding(.bottom, DesignTokens.Spacing.md)

            // Search bar
            HStack(spacing: DesignTokens.Spacing.sm) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(DesignTokens.Colors.tertiaryText)

                TextField("Search notes...", text: $searchText)
                    .font(DesignTokens.Typography.body)
                    .textFieldStyle(PlainTextFieldStyle())

                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(DesignTokens.Colors.tertiaryText)
                    }
                    .transition(.opacity.combined(with: .scale))
                }
            }
            .padding(.horizontal, DesignTokens.Spacing.md)
            .padding(.vertical, DesignTokens.Spacing.sm)
            .modernTextField()

            // Filter tabs
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: DesignTokens.Spacing.xs) {
                    ForEach(NoteFilterType.allCases, id: \.self) { filterType in
                        FilterTab(
                            title: filterType.displayName,
                            count: countForFilter(filterType),
                            isSelected: selectedFilter == filterType
                        ) {
                            selectedFilter = filterType
                        }
                    }
                }
                .padding(.horizontal, DesignTokens.Spacing.lg)
            }
            .padding(.bottom, DesignTokens.Spacing.lg)
        }
        .background(Color(.systemBackground))
            .sheet(isPresented: $showingFolderCreateScreen) {
                FolderCreateScreen(
                    onCreateFolder: { folderName in
                        onCreateFolder(folderName)
                    }
                )
            }
    }

    private func countForFilter(_ filterType: NoteFilterType) -> Int {
        switch filterType {
        case .all:
            return allNotesCount
        case .audio:
            return audioNotesCount
        case .document:
            return documentNotesCount
        case .link:
            return linkNotesCount
        }
    }
}

enum NoteFilterType: CaseIterable {
    case all
    case audio
    case document
    case link

    var displayName: String {
        switch self {
        case .all:
            return "All"
        case .audio:
            return "Audio"
        case .document:
            return "Document"
        case .link:
            return "Link"
        }
    }

    var associatedNoteType: NoteType? {
        switch self {
        case .all:
            return nil
        case .audio:
            return .audio
        case .document:
            return .pdf
        case .link:
            return .webLink
        }
    }
}

struct FilterTab: View {
    let title: String
    let count: Int
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: DesignTokens.Spacing.sm) {
                Text(title)
                    .font(DesignTokens.Typography.callout)
                    .foregroundColor(isSelected ? .white : DesignTokens.Colors.primaryText)

                if count > 0 {
                    Text("\(count)")
                        .font(DesignTokens.Typography.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(isSelected ? .white.opacity(0.9) : DesignTokens.Colors.secondaryText)
                        .padding(.horizontal, DesignTokens.Spacing.sm)
                        .padding(.vertical, 1)
                        .background(
                            Capsule()
                                .fill(isSelected ? .white.opacity(0.2) : DesignTokens.Colors.secondaryBackground)
                        )
                }
            }
            .padding(.horizontal, DesignTokens.Spacing.lg)
            .padding(.vertical, DesignTokens.Spacing.sm)
            .background(
                Capsule()
                    .fill(isSelected ? DesignTokens.Colors.primary : DesignTokens.Colors.secondaryBackground)
            )
        }
        .buttonStyle(.plain)
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

#Preview {
    VStack(spacing: 0) {
        FilterHeaderTabs(
            selectedFilter: .constant(.all),
            selectedFolder: .constant("Default"),
            searchText: .constant(""),
            notes: [],
            onCreateFolder: { folderName in
                print("Creating folder: \(folderName)")
            }
        )

        Spacer()
    }
    .background(Color(.systemGroupedBackground))
}