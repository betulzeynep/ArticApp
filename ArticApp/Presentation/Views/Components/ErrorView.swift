//
//  ErrorView.swift
//  ArticApp
//
//  Created by Zeynep Seyis on 28.09.2025.
//

import SwiftUI

struct ErrorView: View {
    let error: String
    let isOnline: Bool
    let onRetry: () -> Void
    let onUseCached: (() -> Void)?
    
    init(error: String, isOnline: Bool, onRetry: @escaping () -> Void, onUseCached: (() -> Void)? = nil) {
        self.error = error
        self.isOnline = isOnline
        self.onRetry = onRetry
        self.onUseCached = onUseCached
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: isOnline ? "exclamationmark.triangle" : "wifi.slash")
                .font(.system(size: 48))
                .foregroundColor(isOnline ? .orange : .red)
            
            Text(isOnline ? "Oops! Something went wrong" : "No Internet Connection")
                .font(AppFonts.Headline.regular)
                .multilineTextAlignment(.center)
            
            Text(error)
                .multilineTextAlignment(.center)
                .foregroundColor(AppColors.secondaryText)
                .font(AppFonts.Body.regular)
                .padding(.horizontal)
            
            VStack(spacing: 12) {
                Button("Try Again") {
                    onRetry()
                }
                .buttonStyle(.borderedProminent)
                .font(AppFonts.Button.regular)
                
                if let onUseCached = onUseCached {
                    Button("Use Cached Data") {
                        onUseCached()
                    }
                    .buttonStyle(.bordered)
                    .font(AppFonts.Button.regular)
                }
            }
        }
        .padding()
    }
}

#Preview {
    ErrorView(
        error: "Failed to load artworks. Please check your internet connection and try again.",
        isOnline: false,
        onRetry: {},
        onUseCached: {}
    )
}
