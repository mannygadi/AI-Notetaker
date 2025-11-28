//
//  FilterHeaderView.swift
//  AI Notetaker
//
//  Created by Claude on 11/27/25.
//

import SwiftUI

struct FilterHeaderView: View {
    @Binding var selectedFilter: NoteType?
    let notes: [Note]
    let onAddNote: (NoteType) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // "All" filter
                FilterChip(
                    title: "All",
                    isSelected: selectedFilter == nil,
                    count: notes.count
                ) {
                    selectedFilter = nil
                }

                // Note type filters
                ForEach(NoteType.allCases, id: \.self) { noteType in
                    FilterChip(
                        title: noteType.displayName,
                        isSelected: selectedFilter == noteType,
                        icon: noteType.systemImage,
                        iconColor: noteType.systemImageColor,
                        count: notesForType(noteType)
                    ) {
                        onAddNote(noteType)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .background(Color(.systemBackground))
    }

    private func notesForType(_ noteType: NoteType) -> Int {
        return notes.filter { $0.noteTypeEnum == noteType }.count
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let icon: String?
    let iconColor: Color?
    let count: Int
    let action: () -> Void

    init(title: String, isSelected: Bool, icon: String? = nil, iconColor: Color? = nil, count: Int = 0, action: @escaping () -> Void) {
        self.title = title
        self.isSelected = isSelected
        self.icon = icon
        self.iconColor = iconColor
        self.count = count
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(iconColor ?? .primary)
                }

                Text(title)
                    .font(.system(size: 14, weight: .medium))
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
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(isSelected ? Color.blue : Color(.systemGray6))
            )
            .overlay(
                Capsule()
                    .stroke(Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    FilterHeaderView(
        selectedFilter: .constant(nil),
        notes: [],
        onAddNote: { _ in }
    )
}