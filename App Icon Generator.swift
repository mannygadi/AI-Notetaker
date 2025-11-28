//
//  App Icon Generator.swift
//  AI Notetaker
//
//  Created by Claude on 11/28/25.
//  App Icon Generator Script
//

import SwiftUI
import CoreGraphics

struct ModernAppIconGenerator: View {
    @State private var iconSize: CGFloat = 1024
    @State private var showingExport = false

    var body: some View {
        VStack(spacing: 30) {
            Text("Modern App Icon Generator")
                .font(.largeTitle)
                .fontWeight(.bold)

            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.fixed(120), spacing: 20), count: 3), spacing: 20) {
                    AppIconPreview(size: 1024, name: "App Store (1024x1024)")
                    AppIconPreview(size: 512, name: "Mac App Store (512x512)")
                    AppIconPreview(size: 256, name: "Mac App Store (256x256)")
                    AppIconPreview(size: 180, name: "iPhone (180x180)")
                    AppIconPreview(size: 120, name: "iPhone (120x120)")
                    AppIconPreview(size: 80, name: "iPhone (80x80)")
                    AppIconPreview(size: 60, name: "iPhone (60x60)")
                    AppIconPreview(size: 40, name: "iPhone (40x40)")
                    AppIconPreview(size: 29, name: "iPhone (29x29)")
                    AppIconPreview(size: 20, name: "iPhone (20x20)")
                    AppIconPreview(size: 76, name: "iPad (76x76)")
                    AppIconPreview(size: 40, name: "iPad (40x40)")
                    AppIconPreview(size: 167, name: "iPad Pro (167x167)")
                    AppIconPreview(size: 152, name: "iPad (152x152)")
                }
            }
        }
        .padding()
    }
}

struct AppIconPreview: View {
    let size: CGFloat
    let name: String

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                // Background gradient
                RoundedRectangle(cornerRadius: size * 0.2236) // iOS corner radius
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.0, green: 0.48, blue: 1.0),
                                Color(red: 0.0, green: 0.33, blue: 0.88)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: size, height: size)
                    .shadow(color: Color.black.opacity(0.15), radius: size * 0.1, x: 0, y: size * 0.05)

                // Document/note symbol
                VStack(spacing: size * 0.04) {
                    // Note icon
                    ZStack {
                        RoundedRectangle(cornerRadius: size * 0.04)
                            .fill(Color.white.opacity(0.95))
                            .frame(width: size * 0.4, height: size * 0.5)
                            .shadow(color: Color.black.opacity(0.1), radius: size * 0.02)

                        // Lines representing text
                        VStack(spacing: size * 0.02) {
                            HStack(spacing: size * 0.02) {
                                Rectangle()
                                    .fill(Color(red: 0.0, green: 0.48, blue: 1.0))
                                    .frame(width: size * 0.12, height: size * 0.015)
                                Rectangle()
                                    .fill(Color(red: 0.0, green: 0.48, blue: 1.0))
                                    .frame(width: size * 0.08, height: size * 0.015)
                                Rectangle()
                                    .fill(Color(red: 0.0, green: 0.48, blue: 1.0))
                                    .frame(width: size * 0.15, height: size * 0.015)
                            }

                            HStack(spacing: size * 0.02) {
                                Rectangle()
                                    .fill(Color(red: 0.0, green: 0.48, blue: 1.0))
                                    .frame(width: size * 0.18, height: size * 0.015)
                                Rectangle()
                                    .fill(Color(red: 0.0, green: 0.48, blue: 1.0))
                                    .frame(width: size * 0.10, height: size * 0.015)
                            }

                            HStack(spacing: size * 0.02) {
                                Rectangle()
                                    .fill(Color(red: 0.0, green: 0.48, blue: 1.0))
                                    .frame(width: size * 0.14, height: size * 0.015)
                                Rectangle()
                                    .fill(Color(red: 0.0, green: 0.48, blue: 1.0))
                                    .frame(width: size * 0.06, height: size * 0.015)
                            }
                        }
                        .padding(size * 0.05)
                    }

                    // Small "AI" badge
                    Text("AI")
                        .font(.system(size: size * 0.08, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, size * 0.02)
                        .padding(.vertical, size * 0.005)
                        .background(
                            RoundedRectangle(cornerRadius: size * 0.02)
                                .fill(Color(red: 0.0, green: 0.33, blue: 0.88))
                        )
                        .offset(x: size * 0.12, y: -size * 0.15)
                }
            }

            Text("\(Int(size))x\(Int(size))")
                .font(.caption2)
                .foregroundColor(.secondary)

            Text(name)
                .font(.caption2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
}

// Individual App Icon Components for Export
struct AppIcon1024: View {
    var body: some View {
        ZStack {
            // Background gradient
            RoundedRectangle(cornerRadius: 223.6) // iOS corner radius for 1024px
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.0, green: 0.48, blue: 1.0),
                            Color(red: 0.0, green: 0.33, blue: 0.88)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 1024, height: 1024)

            // Document/note symbol
            VStack(spacing: 40) {
                // Note icon
                ZStack {
                    RoundedRectangle(cornerRadius: 40)
                        .fill(Color.white.opacity(0.95))
                        .frame(width: 410, height: 512)
                        .shadow(color: Color.black.opacity(0.1), radius: 20)

                    // Lines representing text
                    VStack(spacing: 20) {
                        HStack(spacing: 20) {
                            Rectangle()
                                .fill(Color(red: 0.0, green: 0.48, blue: 1.0))
                                .frame(width: 123, height: 15)
                            Rectangle()
                                .fill(Color(red: 0.0, green: 0.48, blue: 1.0))
                                .frame(width: 82, height: 15)
                            Rectangle()
                                .fill(Color(red: 0.0, green: 0.48, blue: 1.0))
                                .frame(width: 154, height: 15)
                        }

                        HStack(spacing: 20) {
                            Rectangle()
                                .fill(Color(red: 0.0, green: 0.48, blue: 1.0))
                                .frame(width: 184, height: 15)
                            Rectangle()
                                .fill(Color(red: 0.0, green: 0.48, blue: 1.0))
                                .frame(width: 102, height: 15)
                        }

                        HStack(spacing: 20) {
                            Rectangle()
                                .fill(Color(red: 0.0, green: 0.48, blue: 1.0))
                                .frame(width: 143, height: 15)
                            Rectangle()
                                .fill(Color(red: 0.0, green: 0.48, blue: 1.0))
                                .frame(width: 61, height: 15)
                        }
                    }
                    .padding(50)
                }

                // Small "AI" badge
                Text("AI")
                    .font(.system(size: 82, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(red: 0.0, green: 0.33, blue: 0.88))
                    )
                    .offset(x: 123, y: -154)
            }
        }
    }
}

struct AppIcon512: View {
    var body: some View {
        ZStack {
            // Background gradient
            RoundedRectangle(cornerRadius: 111.8) // iOS corner radius for 512px
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.0, green: 0.48, blue: 1.0),
                            Color(red: 0.0, green: 0.33, blue: 0.88)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 512, height: 512)

            // Document/note symbol
            VStack(spacing: 20) {
                // Note icon
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white.opacity(0.95))
                        .frame(width: 205, height: 256)
                        .shadow(color: Color.black.opacity(0.1), radius: 10)

                    // Lines representing text
                    VStack(spacing: 10) {
                        HStack(spacing: 10) {
                            Rectangle()
                                .fill(Color(red: 0.0, green: 0.48, blue: 1.0))
                                .frame(width: 61, height: 8)
                            Rectangle()
                                .fill(Color(red: 0.0, green: 0.48, blue: 1.0))
                                .frame(width: 41, height: 8)
                            Rectangle()
                                .fill(Color(red: 0.0, green: 0.48, blue: 1.0))
                                .frame(width: 77, height: 8)
                        }

                        HStack(spacing: 10) {
                            Rectangle()
                                .fill(Color(red: 0.0, green: 0.48, blue: 1.0))
                                .frame(width: 92, height: 8)
                            Rectangle()
                                .fill(Color(red: 0.0, green: 0.48, blue: 1.0))
                                .frame(width: 51, height: 8)
                        }

                        HStack(spacing: 10) {
                            Rectangle()
                                .fill(Color(red: 0.0, green: 0.48, blue: 1.0))
                                .frame(width: 71, height: 8)
                            Rectangle()
                                .fill(Color(red: 0.0, green: 0.48, blue: 1.0))
                                .frame(width: 30, height: 8)
                        }
                    }
                    .padding(25)
                }

                // Small "AI" badge
                Text("AI")
                    .font(.system(size: 41, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 2)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(red: 0.0, green: 0.33, blue: 0.88))
                    )
                    .offset(x: 61, y: -77)
            }
        }
    }
}

#Preview {
    ModernAppIconGenerator()
}