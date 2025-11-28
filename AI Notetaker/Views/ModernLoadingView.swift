//
//  ModernLoadingView.swift
//  AI Notetaker
//
//  Created by Claude on 11/28/25.
//

import SwiftUI

struct ModernLoadingView: View {
    @State private var isAnimating = false

    var body: some View {
        HStack(spacing: DesignTokens.Spacing.sm) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(DesignTokens.Colors.primary)
                    .frame(width: 8, height: 8)
                    .scaleEffect(isAnimating ? 1.0 : 0.5)
                    .opacity(isAnimating ? 1.0 : 0.3)
                    .animation(
                        .spring(response: 0.6, dampingFraction: 0.6)
                        .delay(Double(index) * 0.2),
                        value: isAnimating
                    )
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

struct ModernCardLoadingView: View {
    @State private var isAnimating = false
    @State private var opacity: Double = 0.3

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            HStack(spacing: DesignTokens.Spacing.md) {
                RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.medium)
                    .fill(DesignTokens.Colors.tertiaryBackground)
                    .frame(width: 44, height: 44)
                    .opacity(opacity)

                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(DesignTokens.Colors.tertiaryBackground)
                        .frame(height: 16)
                        .opacity(opacity)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(DesignTokens.Colors.tertiaryBackground)
                        .frame(height: 14)
                        .frame(maxWidth: 200)
                        .opacity(opacity)
                }

                Spacer()
            }

            HStack(spacing: DesignTokens.Spacing.xs) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(DesignTokens.Colors.tertiaryBackground)
                    .frame(width: 60, height: 12)
                    .opacity(opacity)

                RoundedRectangle(cornerRadius: 2)
                    .fill(DesignTokens.Colors.tertiaryBackground)
                    .frame(width: 40, height: 12)
                    .opacity(opacity)
            }
        }
        .padding(DesignTokens.Spacing.sm)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                opacity = 0.7
            }
        }
    }
}

#Preview {
    VStack(spacing: DesignTokens.Spacing.lg) {
        ModernLoadingView()

        ModernCardLoadingView()
    }
    .padding(DesignTokens.Spacing.lg)
    .background(DesignTokens.Colors.tertiaryBackground)
}