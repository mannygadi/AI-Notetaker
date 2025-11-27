//
//  AudioRecordingView.swift
//  AI Notetaker
//
//  Created by Claude on 11/27/25.
//

import SwiftUI
import AVFoundation
import CoreData

struct AudioRecordingView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @State private var audioRecorder: AVAudioRecorder?
    @State private var isRecording = false
    @State private var recordingDuration: TimeInterval = 0
    @State private var timer: Timer?
    @State private var title: String = ""
    @State private var showingSaveAlert = false
    @State private var saveError: String?

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Title input
                VStack(alignment: .leading, spacing: 8) {
                    Text("Recording Title")
                        .font(.headline)
                        .foregroundColor(.primary)

                    TextField("Enter recording title...", text: $title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }

                Spacer()

                // Recording interface
                VStack(spacing: 20) {
                    // Recording status indicator
                    ZStack {
                        Circle()
                            .fill(isRecording ? Color.red : Color.gray)
                            .frame(width: 120, height: 120)
                            .scaleEffect(isRecording ? 1.1 : 1.0)
                            .animation(isRecording ? .easeInOut(duration: 1.0).repeatForever() : .default, value: isRecording)

                        Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    }
                    .onTapGesture {
                        if isRecording {
                            stopRecording()
                        } else {
                            startRecording()
                        }
                    }

                    Text(isRecording ? "Tap to stop" : "Tap to record")
                        .font(.headline)
                        .foregroundColor(.secondary)

                    // Duration display
                    Text(formatDuration(recordingDuration))
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                }

                Spacer()

                // Action buttons
                HStack(spacing: 20) {
                    // Cancel button
                    Button("Cancel") {
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                    .tint(.secondary)

                    // Save button (enabled when recording is complete)
                    Button("Save") {
                        saveRecording()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(isRecording || recordingDuration == 0)
                }
                .padding(.bottom, 30)
            }
            .padding()
            .navigationTitle("Audio Recording")
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
                Text(saveError ?? "Unknown error occurred")
            }
        }
    }

    private func startRecording() {
        guard !title.isEmpty else {
            saveError = "Please enter a title for the recording"
            showingSaveAlert = true
            return
        }

        // Request microphone permission
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            if granted {
                do {
                    let audioSession = AVAudioSession.sharedInstance()
                    try audioSession.setCategory(.playAndRecord, mode: .default)
                    try audioSession.setActive(true)

                    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    let audioFilename = documentsPath.appendingPathComponent("\(UUID().uuidString).m4a")

                    let settings = [
                        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                        AVSampleRateKey: 12000,
                        AVNumberOfChannelsKey: 1,
                        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                    ]

                    audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
                    audioRecorder?.record()

                    DispatchQueue.main.async {
                        self.isRecording = true
                        self.startTimer()
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.saveError = "Failed to start recording: \(error.localizedDescription)"
                        self.showingSaveAlert = true
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.saveError = "Microphone permission is required to record audio"
                    self.showingSaveAlert = true
                }
            }
        }
    }

    private func stopRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
        isRecording = false
        stopTimer()
    }

    private func saveRecording() {
        guard let audioRecorder = audioRecorder else {
            saveError = "No recording to save"
            showingSaveAlert = true
            return
        }

        let audioURL = audioRecorder.url

        let finalTitle = title.isEmpty ? "Recording \(DateFormatter.shortTime.string(from: Date()))" : title

        withAnimation {
            let note = Note(context: viewContext, type: .audio, title: finalTitle)
            note.filePath = audioURL.path
            note.duration = recordingDuration
            note.fileName = audioURL.lastPathComponent

            do {
                try viewContext.save()
                dismiss()
            } catch {
                self.saveError = "Failed to save note: \(error.localizedDescription)"
                self.showingSaveAlert = true
            }
        }
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            recordingDuration += 0.1
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

extension DateFormatter {
    static let shortTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
}

#Preview {
    AudioRecordingView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}