//
//  AppColors.swift
//  ArticApp
//
//  Created by Zeynep Seyis on 28.09.2025.
//

import SwiftUI

// MARK: - Simple Color Palette
struct AppColors {
    
    // MARK: - Primary Colors
    static let primary = Color.blue
    static let secondary = Color.green
    static let accent = Color.orange
    
    // MARK: - Background Colors
    static let background = Color(.systemBackground)
    static let secondaryBackground = Color(.secondarySystemBackground)
    
    // MARK: - Text Colors
    static let text = Color.primary
    static let secondaryText = Color.secondary
    static let tertiaryText = Color(.tertiaryLabel)
    
    // MARK: - Status Colors
    static let success = Color.green
    static let warning = Color.orange
    static let error = Color.red
    static let info = Color.blue
    
    // MARK: - Surface Colors
    static let surface = Color(.systemBackground)
    static let elevatedSurface = Color(.secondarySystemBackground)
    
    // MARK: - Border Colors
    static let border = Color(.separator)
    
    // MARK: - Shadow Colors
    static let shadow = Color.black.opacity(0.1)
    static let shadowDark = Color.black.opacity(0.3)
}

#Preview {
    VStack(spacing: 20) {
        Text("Simple Color Palette")
            .font(.title)
            .fontWeight(.bold)
        
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 16) {
            ColorCard(name: "Primary", color: AppColors.primary)
            ColorCard(name: "Secondary", color: AppColors.secondary)
            ColorCard(name: "Accent", color: AppColors.accent)
            ColorCard(name: "Success", color: AppColors.success)
            ColorCard(name: "Warning", color: AppColors.warning)
            ColorCard(name: "Error", color: AppColors.error)
        }
    }
    .padding()
}

struct ColorCard: View {
    let name: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(height: 60)
            
            Text(name)
                .font(.caption)
                .fontWeight(.medium)
        }
    }
}
