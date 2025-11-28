//
//  DesignTokens.swift
//  AI Notetaker
//
//  Created by Claude on 11/28/25.
//

import SwiftUI

// MARK: - Design System Tokens
struct DesignTokens {

    // MARK: - Spacing
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 24
        static let xxl: CGFloat = 32
        static let xxxl: CGFloat = 40
    }

    // MARK: - Corner Radius
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let pill: CGFloat = 28
    }

    // MARK: - Shadow
    struct Shadow {
        static let card: (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) = (
            Color.black.opacity(0.05), 4, 0, 2
        )
        static let floating: (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) = (
            Color.black.opacity(0.1), 8, 0, 4
        )
        static let subtle: (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) = (
            Color.black.opacity(0.03), 2, 0, 1
        )
    }

    // MARK: - Typography
    struct Typography {
        static let largeTitle: Font = .system(size: 28, weight: .bold, design: .rounded)
        static let title1: Font = .system(size: 22, weight: .semibold, design: .rounded)
        static let title2: Font = .system(size: 20, weight: .semibold, design: .rounded)
        static let headline: Font = .system(size: 17, weight: .semibold)
        static let body: Font = .system(size: 16, weight: .regular)
        static let callout: Font = .system(size: 15, weight: .medium)
        static let caption: Font = .system(size: 13, weight: .regular)
        static let footnote: Font = .system(size: 12, weight: .regular)
    }

    // MARK: - Colors
    struct Colors {
        // Primary Blue
        static let primary = Color.blue
        static let primaryDark = Color.blue.opacity(0.8)
        static let primaryLight = Color.blue.opacity(0.1)

        // Semantic Colors
        static let cardBackground = Color(.systemBackground)
        static let secondaryBackground = Color(.secondarySystemBackground)
        static let tertiaryBackground = Color(.tertiarySystemBackground)

        // Text Colors
        static let primaryText = Color.primary
        static let secondaryText = Color.secondary
        static let tertiaryText = Color(.tertiaryLabel)

        // Accent Colors
        static let accent = Color.blue
        static let success = Color.green
        static let warning = Color.orange
        static let error = Color.red
    }
}

// MARK: - View Modifiers for Modern Styling
extension View {

    // Modern Card Style
    func modernCard() -> some View {
        self
            .background(DesignTokens.Colors.cardBackground)
            .cornerRadius(DesignTokens.CornerRadius.medium)
            .shadow(
                color: DesignTokens.Shadow.card.color,
                radius: DesignTokens.Shadow.card.radius,
                x: DesignTokens.Shadow.card.x,
                y: DesignTokens.Shadow.card.y
            )
    }

    // Modern Floating Card Style
    func floatingCard() -> some View {
        self
            .background(DesignTokens.Colors.cardBackground)
            .cornerRadius(DesignTokens.CornerRadius.large)
            .shadow(
                color: DesignTokens.Shadow.floating.color,
                radius: DesignTokens.Shadow.floating.radius,
                x: DesignTokens.Shadow.floating.x,
                y: DesignTokens.Shadow.floating.y
            )
    }

    // Modern TextField Style
    func modernTextField() -> some View {
        self
            .padding(DesignTokens.Spacing.md)
            .background(DesignTokens.Colors.secondaryBackground)
            .cornerRadius(DesignTokens.CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.medium)
                    .stroke(DesignTokens.Colors.tertiaryBackground, lineWidth: 1)
            )
    }

    // Modern Primary Button Style
    func modernPrimaryButton() -> some View {
        self
            .foregroundColor(.white)
            .padding(.horizontal, DesignTokens.Spacing.xl)
            .padding(.vertical, DesignTokens.Spacing.md)
            .background(DesignTokens.Colors.primary)
            .cornerRadius(DesignTokens.CornerRadius.pill)
            .shadow(
                color: DesignTokens.Colors.primary.opacity(0.3),
                radius: 8,
                x: 0,
                y: 4
            )
    }

    // Modern Secondary Button Style
    func modernSecondaryButton() -> some View {
        self
            .foregroundColor(DesignTokens.Colors.primary)
            .padding(.horizontal, DesignTokens.Spacing.lg)
            .padding(.vertical, DesignTokens.Spacing.sm)
            .background(DesignTokens.Colors.primaryLight)
            .cornerRadius(DesignTokens.CornerRadius.medium)
    }
}