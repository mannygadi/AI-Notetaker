//
//  WebLinkSheet.swift
//  AI Notetaker
//
//  Created by Claude on 11/28/25.
//

import SwiftUI
import CoreData

struct WebLinkSheet: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            WebLinkView()
                .environment(\.managedObjectContext, viewContext)
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    WebLinkSheet()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}