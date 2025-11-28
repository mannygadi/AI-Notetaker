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

                VStack(spacing: DesignTokens.Spacing.xxxl) {
                    // Title
                    Text("Create New Folder")
                        .font(DesignTokens.Typography.largeTitle)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    // Folder name input
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                        Text("Folder Name")
                            .font(DesignTokens.Typography.callout)
                            .foregroundColor(DesignTokens.Colors.primaryText)

                        TextField("Enter folder name...", text: $folderName)
                            .modernTextField()
                            .textInputAutocapitalization(.sentences)
                    }
                    .padding(.horizontal, DesignTokens.Spacing.lg)

                    Spacer()
                }
                .padding(.top, DesignTokens.Spacing.xxxl)

                // Bottom button
                HStack {
                    Button(action: {
                        createFolder()
                    }) {
                        HStack(spacing: DesignTokens.Spacing.sm) {
                            Image(systemName: "plus")
                                .font(.system(size: 16, weight: .semibold))

                            Text("New Folder")
                                .font(DesignTokens.Typography.callout)
                        }
                        .modernPrimaryButton()
                    }
                    .disabled(folderName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .opacity(folderName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.6 : 1.0)
                }
                .padding(.horizontal, DesignTokens.Spacing.lg)
                .padding(.bottom, DesignTokens.Spacing.xxxl)
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