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
        HStack(spacing: DesignTokens.Spacing.md) {
            // Modern icon with background
            ZStack {
                RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.medium)
                    .fill(note.noteTypeEnum.systemImageColor.opacity(0.15))
                    .frame(width: 44, height: 44)

                Image(systemName: note.noteTypeEnum.systemImage)
                    .foregroundColor(note.noteTypeEnum.systemImageColor)
                    .font(.system(size: 18, weight: .medium))
            }

            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                Text(note.title ?? "Untitled Note")
                    .font(DesignTokens.Typography.callout)
                    .foregroundColor(DesignTokens.Colors.primaryText)

                Text(note.content ?? "")
                    .font(DesignTokens.Typography.footnote)
                    .foregroundColor(DesignTokens.Colors.secondaryText)
                    .lineLimit(1)

                HStack(spacing: DesignTokens.Spacing.xs) {
                    Text(note.timestamp!, formatter: dateFormatter)
                        .font(DesignTokens.Typography.caption)
                        .foregroundColor(DesignTokens.Colors.tertiaryText)

                    if note.noteTypeEnum == .audio && note.duration > 0 {
                        Text("• \(note.duration, specifier: "%.0f")s")
                            .font(DesignTokens.Typography.caption)
                            .foregroundColor(DesignTokens.Colors.tertiaryText)
                    }
                }
            }

            Spacer(minLength: DesignTokens.Spacing.sm)
        }
        .padding(.vertical, DesignTokens.Spacing.xs)
        .contentShape(Rectangle())
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

