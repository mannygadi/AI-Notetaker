//
//  TextNoteSheet.swift
//  AI Notetaker
//
//  Created by Claude on 11/27/25.
//

import SwiftUI
import CoreData

struct TextNoteSheet: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            TextNoteView()
                .environment(\.managedObjectContext, viewContext)
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    TextNoteSheet()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}