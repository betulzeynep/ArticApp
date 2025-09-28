//
//  NetworkStatusView.swift
//  ArticApp
//
//  Created by Zeynep Seyis on 28.09.2025.
//

import SwiftUI

struct NetworkStatusView: View {
    let isOnline: Bool
    let pendingRequestsCount: Int
    let isShowingCachedData: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: isOnline ? "wifi" : "wifi.slash")
                .foregroundColor(isOnline ? AppColors.success : AppColors.error)
                .font(.caption)
            
            Text(isOnline ? "Connected" : "Offline")
                .font(AppFonts.Caption.small)
                .foregroundColor(AppColors.secondaryText)
            
            if pendingRequestsCount > 0 {
                Text("(\(pendingRequestsCount) queued)")
                    .font(AppFonts.Caption.small)
                    .foregroundColor(AppColors.warning)
            }
            
            if isShowingCachedData {
                Text("(cached)")
                    .font(AppFonts.Caption.small)
                    .foregroundColor(AppColors.info)
            }
        }
    }
}

#Preview {
    VStack {
        NetworkStatusView(
            isOnline: true,
            pendingRequestsCount: 0,
            isShowingCachedData: false
        )
        
        NetworkStatusView(
            isOnline: false,
            pendingRequestsCount: 3,
            isShowingCachedData: true
        )
    }
}
