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
            ScrollView {
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xl) {
                    // Title input section
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                        Text("Note Title")
                            .font(DesignTokens.Typography.callout)
                            .foregroundColor(DesignTokens.Colors.primaryText)

                        TextField("Enter note title...", text: $title)
                            .modernTextField()
                    }
                    .padding(.horizontal, DesignTokens.Spacing.lg)

                    // Content input section
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                        HStack {
                            Text("Note Content")
                                .font(DesignTokens.Typography.callout)
                                .foregroundColor(DesignTokens.Colors.primaryText)

                            Spacer()

                            Text("\(content.count) characters")
                                .font(DesignTokens.Typography.caption)
                                .foregroundColor(DesignTokens.Colors.tertiaryText)
                        }

                        ZStack(alignment: .topLeading) {
                            RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.medium)
                                .fill(DesignTokens.Colors.secondaryBackground)
                                .frame(minHeight: 300)
                                .overlay(
                                    RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.medium)
                                        .stroke(DesignTokens.Colors.tertiaryBackground, lineWidth: 1)
                                )

                            if content.isEmpty {
                                Text("Start typing your note content...")
                                    .foregroundColor(DesignTokens.Colors.tertiaryText)
                                    .padding(DesignTokens.Spacing.md)
                            }

                            TextEditor(text: $content)
                                .padding(DesignTokens.Spacing.sm)
                                .background(Color.clear)
                                .scrollContentBackground(.hidden)
                                .font(DesignTokens.Typography.body)
                        }
                    }
                    .padding(.horizontal, DesignTokens.Spacing.lg)

                    // Action buttons
                    HStack(spacing: DesignTokens.Spacing.xl) {
                        // Cancel button
                        Button("Cancel") {
                            dismiss()
                        }
                        .buttonStyle(.bordered)
                        .tint(.blue)

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
                .padding(.top, 16)
            }
            .navigationTitle("Text Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.blue)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveTextNote()
                    }
                    .disabled(title.isEmpty || content.isEmpty || isSaving)
                    .foregroundColor(.blue)
                }
            }
            .alert("Error", isPresented: $showingSaveAlert) {
                Button("OK", role: .cancel) { }
                .foregroundColor(.blue)
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