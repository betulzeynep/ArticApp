//
//  ArticAppApp.swift
//  ArticApp
//
//  Created by Zeynep Seyis on 28.09.2025.
//

import SwiftUI

@main
struct ArticApp: App {
    @StateObject private var vm: ArtworksViewModel

    init() {
        // Use dependency injection container
        let dependencies = AppDependencies.shared
        _vm = StateObject(wrappedValue: dependencies.createArtworksViewModel())
    }

    var body: some Scene {
        WindowGroup {
            ArtworksGridView(vm: vm)
        }
    }
}
