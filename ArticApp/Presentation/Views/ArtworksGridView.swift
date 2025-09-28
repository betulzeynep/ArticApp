//
//  ArtworksGridView.swift
//  ArticApp
//
//  Created by Zeynep Seyis on 28.09.2025.
//

import SwiftUI
import Kingfisher

struct ArtworksGridView: View {
    @ObservedObject var vm: ArtworksViewModel
    @State private var showingArtistPicker = false
    @State private var searchText = ""
    @State private var selectedArtwork: Artwork?
    @StateObject private var toastManager = ToastManager()
    
    // MARK: - Enhanced Grid Layout
    // Improved grid layout for better visual hierarchy
    let columns = [GridItem(.adaptive(minimum: 160), spacing: 16)]
    
    // MARK: - Helper Functions
    private func hasSufficientData(_ artwork: Artwork) -> Bool {
        return artwork.imageID != nil &&
               (artwork.title != nil || artwork.artistTitle != nil)
    }
    
    private func canShowImage(_ artwork: Artwork) -> Bool {
        // Check if we have image ID and network is available
        // If offline, we can't load new images, so return false
        artwork.imageID != nil && vm.isOnline
    }
    
    private func handleArtworkTap(_ artwork: Artwork) {
        if !hasSufficientData(artwork) {
            toastManager.show("There is not enough information for this artwork 🎨", type: .warning)
            return
        }
        
        if !canShowImage(artwork) {
            toastManager.show("Unable to load image - internet connection required 📡", type: .error)
            return
        }
        
        selectedArtwork = artwork
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // MARK: - Artist Selection Header
                // Added artist selection UI with search functionality
                if !vm.artworks.isEmpty {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(vm.currentArtist)
                                .font(AppFonts.Display.title2)
                            if !vm.totalItemsText.isEmpty {
                                Text(vm.totalItemsText)
                                    .font(AppFonts.Caption.regular)
                                    .foregroundColor(AppColors.secondaryText)
                            }
                            
                            // Debug info for infinite scroll
                            if vm.canLoadMore {
                                Text("(more available)")
                                    .font(AppFonts.Caption.small)
                                    .foregroundColor(AppColors.success)
                            } else if !vm.artworks.isEmpty {
                                Text("(all loaded)")
                                    .font(AppFonts.Caption.small)
                                    .foregroundColor(AppColors.secondaryText)
                            }
                            
                            // MARK: - Network Status Indicator
                            NetworkStatusView(
                                isOnline: vm.isOnline,
                                pendingRequestsCount: vm.pendingRequestsCount,
                                isShowingCachedData: vm.isShowingCachedData
                            )
                        }
                        Spacer()
                        VStack(spacing: 8) {
                            Button("Change Artist") {
                                showingArtistPicker = true
                            }
                            .buttonStyle(.bordered)
                            .font(AppFonts.Button.regular)
                            
                            // Debug button for testing infinite scroll
                            if vm.canLoadMore {
                                Button("Load More") {
                                    Task {
                                        await vm.loadMore()
                                    }
                                }
                                .buttonStyle(.bordered)
                                .font(AppFonts.Button.small)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(AppColors.surface)
                    .shadow(color: AppColors.shadow, radius: 1, y: 1)
                }
                
                Group {
                    if vm.isLoading && vm.artworks.isEmpty {
                        LoadingView(message: "Loading artworks...")
                    } else if let error = vm.errorMessage, vm.artworks.isEmpty {
                        ErrorView(
                            error: error,
                            isOnline: vm.isOnline,
                            onRetry: {
                                Task {
                                    await vm.load(artist: vm.currentArtist, forceRefresh: true)
                                }
                            },
                            onUseCached: vm.isOnline ? nil : {
                                Task {
                                    await vm.load(artist: vm.currentArtist, forceRefresh: false)
                                }
                            }
                        )
                    } else {
                        // MARK: - Artworks Grid with Infinite Scroll and Animations
                        // Enhanced grid with infinite scroll support and staggered animations
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(Array(vm.artworks.enumerated()), id: \.element.id) { index, art in
                                    Button(action: { handleArtworkTap(art) }) {
                                        ArtworkCardView(artwork: art)
                                            .opacity(vm.isLoading ? 0 : 1)
                                            .scaleEffect(vm.isLoading ? 0.8 : 1.0)
                                            .offset(y: vm.isLoading ? 50 : 0)
                                            .animation(
                                                .easeOut(duration: 0.6)
                                                .delay(Double(index) * 0.1),
                                                value: vm.isLoading
                                            )
                                            .padding(8)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .onAppear {
                                        // Trigger infinite scroll when we're near the end
                                        if index >= vm.artworks.count - 3 && vm.canLoadMore {
                                            print("🔄 Near end trigger - index: \(index), count: \(vm.artworks.count)")
                                            Task {
                                                await vm.loadMore()
                                            }
                                        }
                                    }
                                }
                                
                                // MARK: - Infinite Scroll Load More
                                // Added loading indicator for infinite scroll
                                if vm.canLoadMore {
                                    VStack(spacing: 8) {
                                        ProgressView()
                                            .scaleEffect(0.8)
                                        Text("Loading more...")
                                            .font(AppFonts.Caption.regular)
                                            .foregroundColor(AppColors.secondaryText)
                                    }
                                    .frame(height: 60)
                                    .onAppear {
                                        print("🔄 Infinite scroll trigger - canLoadMore: \(vm.canLoadMore)")
                                        Task {
                                            await vm.loadMore()
                                        }
                                    }
                                } else if vm.isLoadingMore {
                                    VStack(spacing: 8) {
                                        ProgressView()
                                            .scaleEffect(0.8)
                                        Text("Loading more...")
                                            .font(AppFonts.Caption.regular)
                                            .foregroundColor(AppColors.secondaryText)
                                    }
                                    .frame(height: 60)
                                }
                            }
                            .padding()
                        }
                        .refreshable {
                            if vm.isOnline {
                                await vm.refreshFromNetwork()
                            } else {
                                // In offline mode, try to reload from cache
                                await vm.load(artist: vm.currentArtist, forceRefresh: false)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Art Institute")
            .navigationBarTitleDisplayMode(.large)
            .task {
                await vm.load(artist: vm.currentArtist)
            }
            .sheet(isPresented: $showingArtistPicker) {
                ArtistSelectionView(viewModel: vm)
            }
            .background(
                NavigationLink(
                    destination: selectedArtwork.map { ArtworkDetailView(artwork: $0) },
                    isActive: Binding(
                        get: { selectedArtwork != nil },
                        set: { if !$0 { selectedArtwork = nil } }
                    )
                ) {
                    EmptyView()
                }
            )
        }
        .overlay(
            // Toast overlay
            VStack {
                ForEach(toastManager.toasts) { toast in
                    ToastView(toast: toast, isShowing: .constant(true))
                        .onTapGesture {
                            toastManager.remove(toast)
                        }
                }
                Spacer()
            }
            .zIndex(1000)
        )
    }
}


