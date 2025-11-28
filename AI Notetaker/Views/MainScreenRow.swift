//
//  MainScreenRow.swift
//  AI Notetaker
//
//  Created by Claude on 11/27/25.
//

import SwiftUI

struct MainScreenRow: View {
    let title: String
    let icon: String
    let iconColor: Color
    let backgroundColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Icon background
                RoundedRectangle(cornerRadius: 10)
                    .fill(backgroundColor)
                    .frame(width: 40, height: 40)
                    .overlay {
                        Image(systemName: icon)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(iconColor)
                    }

                // Title
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.white)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 0) {
        MainScreenRow(
            title: "Record Audio",
            icon: "mic.fill",
            iconColor: .red,
            backgroundColor: Color(red: 1.0, green: 0.9, blue: 0.9)
        ) {}

        Divider()
            .padding(.leading, 52)

        MainScreenRow(
            title: "Audio File",
            icon: "waveform",
            iconColor: .orange,
            backgroundColor: Color(red: 1.0, green: 0.95, blue: 0.85)
        ) {}

        Divider()
            .padding(.leading, 52)

        MainScreenRow(
            title: "PDF & Text File",
            icon: "doc.fill",
            iconColor: .blue,
            backgroundColor: Color(red: 0.9, green: 0.95, blue: 1.0)
        ) {}

        Divider()
            .padding(.leading, 52)

        MainScreenRow(
            title: "Input Text",
            icon: "keyboard",
            iconColor: .green,
            backgroundColor: Color(red: 0.9, green: 1.0, blue: 0.9)
        ) {}

        Divider()
            .padding(.leading, 52)

        MainScreenRow(
            title: "Web Link",
            icon: "globe",
            iconColor: .purple,
            backgroundColor: Color(red: 0.95, green: 0.9, blue: 1.0)
        ) {}
    }
    .background(Color(.systemGroupedBackground))
}