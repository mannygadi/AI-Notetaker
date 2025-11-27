//
//  AudioPlayerView.swift
//  AI Notetaker
//
//  Created by Claude on 11/27/25.
//

import SwiftUI
import AVFoundation
import CoreData

struct AudioPlayerView: View {
    let note: Note

    @State private var audioPlayer: AVAudioPlayer?
    @State internal var isPlaying = false
    @State internal var currentTime: TimeInterval = 0
    @State private var duration: TimeInterval = 0
    @State private var timer: Timer?

    var body: some View {
        VStack(spacing: 20) {
            // Audio file info
            if let fileName = note.fileName {
                HStack {
                    Image(systemName: "waveform")
                        .foregroundColor(.red)
                        .font(.title2)

                    VStack(alignment: .leading) {
                        Text(fileName)
                            .font(.headline)
                            .textSelection(.enabled)

                        if note.duration > 0 {
                            Text("Duration: \(note.duration, specifier: "%.0f") seconds")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    Spacer()
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }

            // Waveform visualization (simplified)
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGray5))
                .frame(height: 100)
                .overlay {
                    HStack(spacing: 2) {
                        ForEach(0..<50, id: \.self) { index in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.red)
                                .frame(width: 3, height: Double.random(in: 20...80))
                                .animation(.easeInOut(duration: 0.5).repeatForever(), value: isPlaying)
                        }
                    }
                }

            // Progress bar
            VStack(spacing: 8) {
                ProgressView(value: currentTime, total: max(duration, 1))
                    .progressViewStyle(LinearProgressViewStyle())
                    .scaleEffect(y: 2)

                HStack {
                    Text(formatTime(currentTime))
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Spacer()

                    Text(formatTime(duration))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            // Playback controls
            HStack(spacing: 40) {
                Button(action: skipBackward) {
                    Image(systemName: "gobackward.15")
                        .font(.title2)
                        .foregroundColor(.red)
                }
                .disabled(audioPlayer == nil)

                Button(action: togglePlayback) {
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.red)
                }
                .disabled(audioPlayer == nil)

                Button(action: skipForward) {
                    Image(systemName: "goforward.15")
                        .font(.title2)
                        .foregroundColor(.red)
                }
                .disabled(audioPlayer == nil)
            }
            .padding(.vertical, 20)
        }
        .onAppear {
            setupAudioPlayer()
        }
        .onDisappear {
            stopTimer()
            audioPlayer?.stop()
        }
    }

    private func setupAudioPlayer() {
        guard let filePath = note.filePath,
              let url = URL(string: "file://\(filePath)") else {
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = AudioPlayerDelegate(parent: self)
            audioPlayer?.prepareToPlay()
            duration = audioPlayer?.duration ?? 0
        } catch {
            print("Failed to setup audio player: \(error)")
        }
    }

    private func togglePlayback() {
        guard let player = audioPlayer else { return }

        if isPlaying {
            player.pause()
            stopTimer()
        } else {
            player.play()
            startTimer()
        }
        isPlaying = player.isPlaying
    }

    private func skipForward() {
        guard let player = audioPlayer else { return }
        let newTime = min(currentTime + 15, duration)
        player.currentTime = newTime
        currentTime = newTime
    }

    private func skipBackward() {
        guard let player = audioPlayer else { return }
        let newTime = max(currentTime - 15, 0)
        player.currentTime = newTime
        currentTime = newTime
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if let player = audioPlayer {
                currentTime = player.currentTime
            }
        }
    }

    internal func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

class AudioPlayerDelegate: NSObject, AVAudioPlayerDelegate {
    var parent: AudioPlayerView?

    init(parent: AudioPlayerView) {
        self.parent = parent
        super.init()
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        parent?.isPlaying = false
        parent?.currentTime = 0
        parent?.stopTimer()
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let note = Note(context: context, type: .audio, title: "Test Recording")
    note.fileName = "test.m4a"
    note.duration = 120.0

    return AudioPlayerView(note: note)
}