//
//  AI_NotetakerApp.swift
//  AI Notetaker
//
//  Created by Manohar Gadiraju on 11/27/25.
//

import SwiftUI
import CoreData

@main
struct AI_NotetakerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
