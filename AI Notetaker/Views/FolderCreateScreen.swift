//
//  FolderCreateScreen.swift
//  AI Notetaker
//
//  Created by Claude on 11/27/25.
//

import SwiftUI
import CoreData

struct FolderCreateScreen: View {
    @State private var folderName: String = ""
    let onCreateFolder: (String) -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header with back button and title
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.primary)
                    }

                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)

                VStack(spacing: 40) {
                    // Title
                    Text("Create New Folder")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    // Folder name input
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Folder Name")
                            .font(.headline)
                            .foregroundColor(.primary)

                        TextField("Enter folder name...", text: $folderName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .textInputAutocapitalization(.sentences)
                    }
                    .padding(.horizontal)

                    Spacer()
                }
                .padding(.top, 60)

                // Bottom button
                HStack {
                    Button(action: {
                        createFolder()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "plus")
                                .font(.system(size: 16, weight: .semibold))

                            Text("New Folder")
                                .font(.system(size: 16, weight: .medium))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                        .background(Color.blue)
                        .cornerRadius(28)
                        .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .disabled(folderName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .opacity(folderName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.6 : 1.0)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
            }
            .navigationBarHidden(true)
            .background(Color(.systemBackground))
        }
        .navigationBarHidden(true)
    }

    private func createFolder() {
        let cleanFolderName = folderName.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !cleanFolderName.isEmpty else {
            return
        }

        onCreateFolder(cleanFolderName)
        dismiss()
    }
}

#Preview {
    FolderCreateScreen(onCreateFolder: { folderName in
        print("Creating folder: \(folderName)")
    })
}