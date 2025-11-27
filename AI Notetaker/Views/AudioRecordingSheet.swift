//
//  AudioRecordingSheet.swift
//  AI Notetaker
//
//  Created by Claude on 11/27/25.
//

import SwiftUI

struct AudioRecordingSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext

    let onRecordingComplete: (Note) -> Void

    var body: some View {
        AudioRecordingView()
            .environment(\.managedObjectContext, viewContext)
            .onDisappear {
                // The sheet is dismissed when recording is saved or cancelled
            }
    }
}

// Extension to make it easier to present the recording sheet
extension View {
    func audioRecordingSheet(isPresented: Binding<Bool>, onRecordingComplete: @escaping (Note) -> Void) -> some View {
        self.sheet(isPresented: isPresented) {
            AudioRecordingSheet(onRecordingComplete: onRecordingComplete)
        }
    }
}