//
//  NoteDetailView.swift
//  AI Notetaker
//
//  Created by Claude on 11/27/25.
//

import SwiftUI
import CoreData

struct NoteDetailView: View {
    let note: Note

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header with type and timestamp
                HStack {
                    Image(systemName: note.noteTypeEnum.systemImage)
                        .foregroundColor(note.noteTypeEnum.systemImageColor)
                        .font(.largeTitle)

                    VStack(alignment: .leading) {
                        Text(note.noteTypeEnum.displayName)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .textCase(.uppercase)

                        Text(note.timestamp!, formatter: detailDateFormatter)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Spacer()
                }

                // Title
                Text(note.title ?? "Untitled Note")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 10)

                // Content based on note type
                VStack(alignment: .leading, spacing: 15) {
                    switch note.noteTypeEnum {
                    case .audio:
                        audioContentView
                    case .text:
                        textContentView
                    case .pdf:
                        pdfContentView
                    case .webLink:
                        webLinkContentView
                    }
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private var audioContentView: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Audio player
            AudioPlayerView(note: note)

            if let transcription = note.transcription, !transcription.isEmpty {
                VStack(alignment: .leading) {
                    Text("Transcription")
                        .font(.headline)
                    Text(transcription)
                        .font(.body)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
            }
        }
    }

    @ViewBuilder
    private var textContentView: some View {
        Text(note.content ?? "")
            .font(.body)
            .textSelection(.enabled)
    }

    @ViewBuilder
    private var pdfContentView: some View {
        VStack(alignment: .leading, spacing: 15) {
            if let fileName = note.fileName {
                HStack {
                    Image(systemName: "doc")
                    Text(fileName)
                        .font(.subheadline)
                }
            }

            if note.content?.isEmpty == false {
                Text(note.content ?? "")
                    .font(.body)
            } else {
                Text("PDF document stored locally")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        }
    }

    @ViewBuilder
    private var webLinkContentView: some View {
        VStack(alignment: .leading, spacing: 15) {
            if let webURL = note.webURL {
                Link(destination: URL(string: webURL)!) {
                    HStack {
                        Image(systemName: "safari")
                        Text(webURL)
                            .font(.subheadline)
                            .foregroundColor(.blue)
                        Spacer()
                        Image(systemName: "arrow.up.right")
                            .font(.caption)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
            }

            if note.content?.isEmpty == false {
                Text(note.content ?? "")
                    .font(.body)
            }
        }
    }
}

private let detailDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()

