//
//  TextNoteView.swift
//  AI Notetaker
//
//  Created by Claude on 11/27/25.
//

import SwiftUI
import CoreData

struct TextNoteView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var content: String = ""
    @State private var showingSaveAlert = false
    @State private var saveError: String?
    @State private var isSaving = false

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                // Title input section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Note Title")
                        .font(.headline)
                        .foregroundColor(.primary)

                    TextField("Enter note title...", text: $title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }
                .padding(.top)

                // Content input section
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Note Content")
                            .font(.headline)
                            .foregroundColor(.primary)

                        Spacer()

                        Text("\(content.count) characters")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemGray6))
                            .frame(minHeight: 300)

                        if content.isEmpty {
                            Text("Start typing your note content...")
                                .foregroundColor(.secondary)
                                .padding()
                        }

                        TextEditor(text: $content)
                            .padding(8)
                            .background(Color.clear)
                            .scrollContentBackground(.hidden)
                    }
                    .padding(.horizontal)
                }

                Spacer()

                // Action buttons
                HStack(spacing: 20) {
                    // Cancel button
                    Button("Cancel") {
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                    .tint(.secondary)

                    Spacer()

                    // Save button
                    Button("Save Note") {
                        saveTextNote()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(title.isEmpty || content.isEmpty || isSaving)

                    if isSaving {
                        ProgressView()
                            .scaleEffect(0.8)
                            .padding(.leading, 8)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
            .navigationTitle("Text Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveTextNote()
                    }
                    .disabled(title.isEmpty || content.isEmpty || isSaving)
                }
            }
            .alert("Error", isPresented: $showingSaveAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(saveError ?? "Unknown error occurred")
            }
        }
    }

    private func saveTextNote() {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            saveError = "Please enter a title for the note"
            showingSaveAlert = true
            return
        }

        guard !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            saveError = "Please enter content for the note"
            showingSaveAlert = true
            return
        }

        isSaving = true

        let finalTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let finalContent = content.trimmingCharacters(in: .whitespacesAndNewlines)

        withAnimation {
            let note = Note(context: viewContext, type: .text, title: finalTitle)
            note.content = finalContent
            note.duration = 0 // Text notes don't have duration

            do {
                try viewContext.save()
                dismiss()
            } catch {
                self.saveError = "Failed to save note: \(error.localizedDescription)"
                self.showingSaveAlert = true
                isSaving = false
            }
        }
    }
}

#Preview {
    TextNoteView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}