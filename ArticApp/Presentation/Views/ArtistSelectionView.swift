//
//  ArtistSelectionView.swift
//  ArticApp
//
//  Created by Zeynep Seyis on 28.09.2025.
//

import SwiftUI

// MARK: - Artist Selection View
// New view for artist selection with popular artists and search functionality
struct ArtistSelectionView: View {
    @StateObject private var selectionViewModel: ArtistSelectionViewModel
    @ObservedObject var artworksViewModel: ArtworksViewModel
    
    init(viewModel: ArtworksViewModel) {
        self.artworksViewModel = viewModel
        let dependencies = AppDependencies.shared
        _selectionViewModel = StateObject(wrappedValue: dependencies.createArtistSelectionViewModel())
    }
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var selectedArtist = ""
    
    // MARK: - Popular Artists List
    // Curated list of popular artists from the Art Institute collection
    private var popularArtists: [String] {
        selectionViewModel.popularArtists
    }
    
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
            VStack(spacing: 0) {
                // MARK: - Search Bar
                // Added search functionality for custom artist names
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(AppColors.secondaryText)
                    TextField("Search for an artist...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding()
                
                // MARK: - Artist List
                // Enhanced list with search filtering and selection
                List {
                    if !searchText.isEmpty {
                        // MARK: - Custom Search Result
                        // Handle custom artist search
                        HStack {
                            Image(systemName: "person.circle")
                                .foregroundColor(AppColors.primary)
                            Text("Search for: \"\(searchText)\"")
                                .font(AppFonts.Body.medium)
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedArtist = searchText
                            Task {
                                await artworksViewModel.load(artist: searchText)
                                dismiss()
                            }
                        }
                    }
                    
                    // MARK: - Popular Artists Section
                    Section(header: Text("Popular Artists")) {
                        ForEach(popularArtists.filter { artist in
                            searchText.isEmpty || artist.localizedCaseInsensitiveContains(searchText)
                        }, id: \.self) { artist in
                            HStack {
                                Image(systemName: "paintbrush.pointed")
                                    .foregroundColor(AppColors.accent)
                                Text(artist)
                                    .font(AppFonts.Body.regular)
                                Spacer()
                                if artist == artworksViewModel.currentArtist {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(AppColors.primary)
                                        .font(.system(size: 14, weight: .semibold))
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedArtist = artist
                                Task {
                                    await artworksViewModel.load(artist: artist)
                                    dismiss()
                                }
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationTitle("Select Artist")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            }
        } else {
            NavigationView {
            VStack(spacing: 0) {
                // MARK: - Search Bar
                // Added search functionality for custom artist names
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.blue)
                    TextField("Search for an artist...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding()
                
                // MARK: - Search Results
                List {
                    if !searchText.isEmpty {
                        HStack {
                            Image(systemName: "person.circle")
                                .foregroundColor(AppColors.primary)
                            Text("Search for: \"\(searchText)\"")
                                .font(AppFonts.Body.medium)
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedArtist = searchText
                            Task {
                                await artworksViewModel.load(artist: searchText)
                                dismiss()
                            }
                        }
                    }
                    
                    // MARK: - Popular Artists Section
                    Section(header: Text("Popular Artists")) {
                        ForEach(popularArtists.filter { artist in
                            searchText.isEmpty || artist.localizedCaseInsensitiveContains(searchText)
                        }, id: \.self) { artist in
                            HStack {
                                Image(systemName: "paintbrush.pointed")
                                    .foregroundColor(AppColors.accent)
                                Text(artist)
                                    .font(AppFonts.Body.regular)
                                Spacer()
                                if artist == artworksViewModel.currentArtist {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(AppColors.primary)
                                        .font(.system(size: 14, weight: .semibold))
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedArtist = artist
                                Task {
                                    await artworksViewModel.load(artist: artist)
                                    dismiss()
                                }
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationTitle("Select Artist")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            }
        }
    }
}

#Preview {
    let dependencies = AppDependencies.shared
    ArtistSelectionView(viewModel: dependencies.createArtworksViewModel())
}
