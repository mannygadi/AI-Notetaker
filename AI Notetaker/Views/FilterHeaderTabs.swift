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
    let notes: [Note]

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

    var body: some View {
        VStack(spacing: 0) {
            // Folder selection row
            HStack {
                Button(action: {
                    // TODO: Show folder selection modal
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "folder")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.blue)

                        Text(selectedFolder)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.primary)

                        Image(systemName: "chevron.down")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                .buttonStyle(.plain)

                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 8)
            .padding(.bottom, 12)

            // Filter tabs
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 4) {
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
                .padding(.horizontal)
            }
            .padding(.bottom, 16)
        }
        .background(Color(.systemBackground))
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
            HStack(spacing: 6) {
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(isSelected ? .white : .primary)

                if count > 0 {
                    Text("\(count)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(isSelected ? .white.opacity(0.2) : Color(.systemGray5))
                        )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(isSelected ? Color.blue : Color(.systemGray6))
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 0) {
        FilterHeaderTabs(
            selectedFilter: .constant(.all),
            selectedFolder: .constant("Default"),
            notes: []
        )

        Spacer()
    }
    .background(Color(.systemGroupedBackground))
}