//
//  NoteRowView.swift
//  AI Notetaker
//
//  Created by Claude on 11/27/25.
//

import SwiftUI
import CoreData

struct NoteRowView: View {
    let note: Note

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: note.noteTypeEnum.systemImage)
                .foregroundColor(note.noteTypeEnum.systemImageColor)
                .font(.title2)
                .frame(width: 30, height: 30)

            VStack(alignment: .leading, spacing: 4) {
                Text(note.title ?? "Untitled Note")
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(note.content ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)

                HStack {
                    Text(note.timestamp!, formatter: dateFormatter)
                        .font(.caption)
                        .foregroundColor(.secondary)

                    if note.noteTypeEnum == .audio && note.duration > 0 {
                        Text("• \(note.duration, specifier: "%.0f")s")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

