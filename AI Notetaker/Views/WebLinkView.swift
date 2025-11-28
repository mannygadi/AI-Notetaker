//
//  WebLinkView.swift
//  AI Notetaker
//
//  Created by Claude on 11/28/25.
//

import SwiftUI
import CoreData

struct WebLinkView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @State private var urlText: String = ""
    @State private var title: String = ""
    @State private var showingSaveAlert = false
    @State private var saveError: String?
    @State private var isSaving = false
    @State private var isValidURL = false
    @State private var isFetchingContent = false
    @State private var fetchedContent: String = ""

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header section
                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: "globe")
                                .font(.system(size: 40))
                                .foregroundColor(.purple)
                                .frame(width: 60, height: 60)
                                .background(Color(.systemPurple).opacity(0.1))
                                .cornerRadius(12)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Add Web Link")
                                    .font(.title2)
                                    .fontWeight(.bold)

                                Text("Enter a URL to save and fetch its content")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)

                            Spacer()
                        }
                    }
                    .padding(.horizontal)

                    // URL input section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("URL")
                            .font(.headline)
                            .foregroundColor(.primary)

                        HStack(spacing: 12) {
                            Image(systemName: "link")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.secondary)

                            TextField("Enter web link...", text: $urlText)
                                .keyboardType(.URL)
                                .autocapitalization(.none)
                                .autocorrectionDisabled()
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .onChange(of: urlText) { _ in
                                    validateURL()
                                }

                            if urlText.count > 0 {
                                Button(action: {
                                    urlText = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size: 16))
                                        .foregroundColor(.secondary)
                                }
                                .transition(.opacity)
                            }
                        }
                    }
                    .padding(.horizontal)

                    // Title input section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Title")
                            .font(.headline)
                            .foregroundColor(.primary)

                        HStack(spacing: 12) {
                            Image(systemName: "textformat")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.secondary)

                            TextField("Enter note title...", text: $title)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                    .padding(.horizontal)

                    // Fetch content section
                    if isValidURL {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Content")
                                    .font(.headline)
                                    .foregroundColor(.primary)

                                Spacer()

                                if isFetchingContent {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                } else if !fetchedContent.isEmpty {
                                    Button("Clear") {
                                        fetchedContent = ""
                                    }
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                }
                            }

                            ScrollView {
                                Text(fetchedContent.isEmpty ?
                                    (isFetchingContent ? "Fetching content..." : "No content fetched") :
                                    fetchedContent
                                )
                                .font(.body)
                                .foregroundColor(fetchedContent.isEmpty ? .secondary : .primary)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .frame(minHeight: 150)
                            }

                            Button(action: {
                                fetchWebContent()
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: isFetchingContent ? "hourglass" : "arrow.clockwise")
                                        .font(.system(size: 14, weight: .medium))

                                    Text(isFetchingContent ? "Fetching..." : "Fetch Content")
                                        .font(.system(size: 14, weight: .medium))
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(isFetchingContent ? Color.gray : Color.blue)
                                .cornerRadius(8)
                            }
                            .disabled(isFetchingContent || !isValidURL)
                        }
                        .padding(.horizontal)
                    }

                    Spacer()

                    // Save button
                    VStack(spacing: 16) {
                        Button(action: {
                            saveWebLinkNote()
                        }) {
                            HStack(spacing: 8) {
                                if isSaving {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Image(systemName: "globe")
                                        .font(.system(size: 18, weight: .medium))
                                }

                                Text(isSaving ? "Saving..." : "Save Web Link")
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 16)
                            .background(isSaving ? Color.blue.opacity(0.8) : Color.purple)
                            .cornerRadius(28)
                            .disabled(isSaving || !isValidURL || title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 40)
                    }
                }
                .padding(.top, 16)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Error", isPresented: $showingSaveAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(saveError ?? "An error occurred while saving the web link")
            }
        }
    }

    private func validateURL() {
        let trimmedURL = urlText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        isValidURL = isValidWebURL(trimmedURL)
    }

    private func isValidWebURL(_ urlString: String) -> Bool {
        guard let url = URL(string: urlString) else { return false }
        return url.scheme == "http" || url.scheme == "https"
    }

    private func fetchWebContent() {
        guard let url = URL(string: urlText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)) else { return }

        isFetchingContent = true
        fetchedContent = ""

        Task {
            do {
                let (data, response) = try await URLSession.shared.data(from: url)

                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        if let htmlString = String(data: data, encoding: .utf8) {
                            // Simple text extraction from HTML
                            let cleanContent = extractTextFromHTML(htmlString)
                            await MainActor.run {
                                fetchedContent = cleanContent.isEmpty ? "Content fetched but no readable text found" : cleanContent
                            }
                        } else {
                            await MainActor.run {
                                fetchedContent = "Content type not readable"
                            }
                        }
                    } else {
                        await MainActor.run {
                            fetchedContent = "HTTP Error: \(httpResponse.statusCode)"
                        }
                    }
                }
            } catch {
                await MainActor.run {
                    fetchedContent = "Failed to fetch content: \(error.localizedDescription)"
                }
            }

            await MainActor.run {
                isFetchingContent = false
            }
        }
    }

    private func extractTextFromHTML(_ html: String) -> String {
        // Remove HTML tags and extract readable text
        let regex = try? NSRegularExpression(pattern: "<[^>]+>")
        let range = NSRange(location: 0, length: html.utf16.count)
        let cleanHTML = regex?.stringByReplacingMatches(in: html, options: [], range: range, withTemplate: "")

        // Clean up whitespace and line breaks
        let cleanedText = cleanHTML?
            .components(separatedBy: CharacterSet.whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
            .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        return cleanedText ?? ""
    }

    private func saveWebLinkNote() {
        guard isValidURL,
              let url = URL(string: urlText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)),
              !title.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
            saveError = "Please enter a valid URL and title"
            showingSaveAlert = true
            return
        }

        isSaving = true

        let finalTitle = title.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let finalURL = urlText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let finalContent = fetchedContent.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        withAnimation {
            let note = Note(context: viewContext, type: .webLink, title: finalTitle)
            note.webURL = finalURL
            note.content = finalContent.isEmpty ? "Web link: \(finalURL)" : finalContent
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
}

#Preview {
    WebLinkView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}