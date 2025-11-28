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
            HStack(spacing: DesignTokens.Spacing.lg) {
                // Modern icon with gradient background
                ZStack {
                    RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.large)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [backgroundColor, backgroundColor.opacity(0.7)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 52, height: 52)
                        .shadow(color: backgroundColor.opacity(0.3), radius: 4, x: 0, y: 2)

                    Image(systemName: icon)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(iconColor)
                }

                // Title with modern typography
                Text(title)
                    .font(DesignTokens.Typography.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(DesignTokens.Colors.primaryText)

                Spacer()
            }
            .padding(.horizontal, DesignTokens.Spacing.xl)
            .padding(.vertical, DesignTokens.Spacing.lg)
            .background(DesignTokens.Colors.cardBackground)
            .cornerRadius(DesignTokens.CornerRadius.large)
            .floatingCard()
        }
        .buttonStyle(.plain)
        .scaleEffect(1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: UUID().uuidString)
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
                .padding(.leading, DesignTokens.Spacing.xxxl)

        MainScreenRow(
            title: "Audio File",
            icon: "waveform",
            iconColor: .orange,
            backgroundColor: Color(red: 1.0, green: 0.95, blue: 0.85)
        ) {}

        Divider()
                .padding(.leading, DesignTokens.Spacing.xxxl)

        MainScreenRow(
            title: "PDF & Text File",
            icon: "doc.fill",
            iconColor: .blue,
            backgroundColor: Color(red: 0.9, green: 0.95, blue: 1.0)
        ) {}

        Divider()
                .padding(.leading, DesignTokens.Spacing.xxxl)

        MainScreenRow(
            title: "Input Text",
            icon: "keyboard",
            iconColor: .green,
            backgroundColor: Color(red: 0.9, green: 1.0, blue: 0.9)
        ) {}

        Divider()
                .padding(.leading, DesignTokens.Spacing.xxxl)

        MainScreenRow(
            title: "Web Link",
            icon: "globe",
            iconColor: .purple,
            backgroundColor: Color(red: 0.95, green: 0.9, blue: 1.0)
        ) {}
    }
    .background(DesignTokens.Colors.tertiaryBackground)
}