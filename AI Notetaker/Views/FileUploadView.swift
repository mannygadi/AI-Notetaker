//
//  FileUploadView.swift
//  AI Notetaker
//
//  Created by Claude on 11/28/25.
//

import SwiftUI
import UniformTypeIdentifiers
import CoreServices
import CoreData

struct FileUploadView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @State private var showingFilePicker = false
    @State private var selectedFile: URL?
    @State private var fileData: Data?
    @State private var fileName: String?
    @State private var fileSize: Int64 = 0
    @State private var showingSaveAlert = false
    @State private var saveError: String?
    @State private var isSaving = false

    private var documentTypes: [UTType] {
        [
            .pdf,
            .text,
            .plainText,
            .rtf,
            .xml,
            .commaSeparatedText
        ]
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Header section
                VStack(spacing: 16) {
                    HStack {
                        Image(systemName: "doc.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.blue)
                            .frame(width: 60, height: 60)
                            .background(Color(.systemBlue).opacity(0.1))
                            .cornerRadius(12)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Upload Document")
                                .font(.title2)
                                .fontWeight(.bold)

                            Text("Select a PDF or text file to add to your notes")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        Spacer()
                    }

                    // Upload button
                    Button(action: {
                        showingFilePicker = true
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 20))

                            Text("Choose File")
                                .font(.system(size: 16, weight: .medium))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal)

                Spacer()

                // File preview section
                if let selectedFile = selectedFile {
                    VStack(spacing: 16) {
                        // File info card
                        VStack(spacing: 12) {
                            HStack {
                                Image(systemName: fileIcon(for: selectedFile))
                                    .font(.system(size: 28))
                                    .foregroundColor(fileIconColor(for: selectedFile))
                                    .frame(width: 50, height: 50)
                                    .background(fileIconBackgroundColor(for: selectedFile))
                                    .cornerRadius(10)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(fileName ?? "Unknown File")
                                        .font(.headline)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.leading)

                                    Text(formattedFileSize(fileSize))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)

                                Button(action: {
                                    self.selectedFile = nil
                                    fileData = nil
                                    fileName = nil
                                    fileSize = 0
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(16)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }

                        Spacer()

                        // Save button
                        Button(action: {
                            saveFileNote()
                        }) {
                            HStack(spacing: 8) {
                                if isSaving {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 18, weight: .medium))
                                }

                                Text(isSaving ? "Saving..." : "Save Note")
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 16)
                            .background(isSaving ? Color.blue.opacity(0.8) : Color.blue)
                            .cornerRadius(28)
                            .disabled(isSaving || selectedFile == nil)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .fileImporter(
                isPresented: $showingFilePicker,
                allowedContentTypes: documentTypes,
                allowsMultipleSelection: false
            ) { result in
                handleFileSelection(result)
            }
            .alert("Error", isPresented: $showingSaveAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(saveError ?? "An error occurred while saving the file")
            }
        }
    }

    private func handleFileSelection(_ result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            guard let url = urls.first else { return }

            // Start accessing the file
            let accessing = url.startAccessingSecurityScopedResource()

            if accessing {
                selectedFile = url
                fileName = url.lastPathComponent
                fileSize = fileSizeForURL(url)

                // Read file data asynchronously
                Task {
                    do {
                        let data = try Data(contentsOf: url)
                        await MainActor.run {
                            fileData = data
                        }
                    } catch {
                        await MainActor.run {
                            saveError = "Failed to read file: \(error.localizedDescription)"
                            showingSaveAlert = true
                        }
                    }

                    url.stopAccessingSecurityScopedResource()
                }
            }

        case .failure(let error):
            saveError = "Failed to select file: \(error.localizedDescription)"
            showingSaveAlert = true
        }
    }

    private func saveFileNote() {
        guard let selectedFile = selectedFile,
              let fileName = fileName,
              !fileName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            saveError = "Please select a file to save"
            showingSaveAlert = true
            return
        }

        isSaving = true

        let finalFileName = fileName.trimmingCharacters(in: .whitespacesAndNewlines)

        withAnimation {
            let note = Note(context: viewContext, type: .pdf, title: finalFileName)
            note.fileName = finalFileName
            note.filePath = selectedFile.path
            note.duration = 0

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

    private func fileSizeForURL(_ url: URL) -> Int64 {
        do {
            let resourceValues = try url.resourceValues(forKeys: [.fileSizeKey])
            return Int64(resourceValues.fileSize ?? 0)
        } catch {
            return 0
        }
    }

    private func formattedFileSize(_ size: Int64) -> String {
        let byteCountFormatter = ByteCountFormatter()
        byteCountFormatter.allowedUnits = [.useKB, .useMB, .useGB]
        byteCountFormatter.countStyle = .file
        return byteCountFormatter.string(fromByteCount: size)
    }

    private func fileIcon(for url: URL) -> String {
        switch url.pathExtension.lowercased() {
        case "pdf":
            return "doc.fill"
        case "txt", "text":
            return "doc.text.fill"
        case "rtf":
            return "doc.richtext.fill"
        case "xml":
            return "doc.text.fill"
        default:
            return "doc.fill"
        }
    }

    private func fileIconColor(for url: URL) -> Color {
        switch url.pathExtension.lowercased() {
        case "pdf":
            return .red
        case "txt", "text", "rtf", "xml":
            return .blue
        default:
            return .gray
        }
    }

    private func fileIconBackgroundColor(for url: URL) -> Color {
        switch url.pathExtension.lowercased() {
        case "pdf":
            return Color(red: 1.0, green: 0.9, blue: 0.9)
        case "txt", "text", "rtf", "xml":
            return Color(red: 0.9, green: 0.95, blue: 1.0)
        default:
            return Color(.systemGray6)
        }
    }
}

#Preview {
    FileUploadView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}