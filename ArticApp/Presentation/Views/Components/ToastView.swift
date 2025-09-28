//
//  ToastView.swift
//  ArticApp
//
//  Created by Zeynep Seyis on 28.09.2025.
//

import SwiftUI
import Combine

// MARK: - Simple Toast Message
struct ToastMessage: Identifiable {
    let id = UUID()
    let message: String
    let type: ToastType
    let duration: TimeInterval
    
    init(message: String, type: ToastType = .info, duration: TimeInterval = 2.5) {
        self.message = message
        self.type = type
        self.duration = duration
    }
}

enum ToastType {
    case success
    case error
    case warning
    case info
    
    var icon: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .info: return "info.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .success: return .green
        case .error: return .red
        case .warning: return .orange
        case .info: return .blue
        }
    }
}

// MARK: - Simple Toast View
struct ToastView: View {
    let toast: ToastMessage
    @Binding var isShowing: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: toast.type.icon)
                .foregroundColor(toast.type.color)
                .font(.system(size: 16, weight: .semibold))
            
            Text(toast.message)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
            
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.regularMaterial)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .padding(.horizontal, 20)
        .transition(.asymmetric(
            insertion: .move(edge: .top).combined(with: .opacity),
            removal: .move(edge: .top).combined(with: .opacity)
        ))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isShowing = false
                }
            }
        }
    }
}

// MARK: - Simple Toast Manager
@MainActor
class ToastManager: ObservableObject {
    @Published var toasts: [ToastMessage] = []
    
    func show(_ message: String, type: ToastType = .info, duration: TimeInterval = 2.5) {
        let toast = ToastMessage(message: message, type: type, duration: duration)
        toasts.append(toast)
        
        // Auto remove after duration
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.remove(toast)
        }
    }
    
    func remove(_ toast: ToastMessage) {
        withAnimation(.easeInOut(duration: 0.3)) {
            toasts.removeAll { $0.id == toast.id }
        }
    }
}


#Preview {
    VStack(spacing: 20) {
        Button("Show Success Toast") {
            // Example usage
        }
        
        Button("Show Error Toast") {
            // Example usage
        }
    }
}
