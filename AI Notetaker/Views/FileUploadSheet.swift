//
//  FileUploadSheet.swift
//  AI Notetaker
//
//  Created by Claude on 11/28/25.
//

import SwiftUI
import CoreData

struct FileUploadSheet: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            FileUploadView()
                .environment(\.managedObjectContext, viewContext)
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    FileUploadSheet()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}