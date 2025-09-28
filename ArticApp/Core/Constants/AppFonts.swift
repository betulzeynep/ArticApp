//
//  AppFonts.swift
//  ArticApp
//
//  Created by Zeynep Seyis on 28.09.2025.
//

import SwiftUI

// MARK: - Simple Font System
struct AppFonts {
    
    // MARK: - Display Fonts
    struct Display {
        static let largeTitle = Font.largeTitle.weight(.bold)
        static let title = Font.title.weight(.bold)
        static let title2 = Font.title2.weight(.semibold)
        static let title3 = Font.title3.weight(.semibold)
    }
    
    // MARK: - Body Fonts
    struct Body {
        static let large = Font.title3
        static let regular = Font.body
        static let medium = Font.body.weight(.medium)
        static let small = Font.subheadline
    }
    
    // MARK: - Headline Fonts
    struct Headline {
        static let large = Font.title2.weight(.bold)
        static let regular = Font.headline
        static let small = Font.callout.weight(.semibold)
    }
    
    // MARK: - Caption Fonts
    struct Caption {
        static let regular = Font.caption
        static let small = Font.caption2
        static let bold = Font.caption.weight(.semibold)
    }
    
    // MARK: - Button Fonts
    struct Button {
        static let large = Font.callout.weight(.semibold)
        static let regular = Font.subheadline.weight(.medium)
        static let small = Font.caption.weight(.medium)
    }
    
    // MARK: - Card Fonts
    struct Card {
        static let title = Font.subheadline.weight(.semibold)
        static let subtitle = Font.caption
        static let body = Font.caption
    }
}

// MARK: - Font Extensions
extension Font {
    @available(iOS 16.0, *)
    static func appFont(_ size: Font.TextStyle, weight: Font.Weight = .regular) -> Font {
        return Font.system(size, weight: weight)
    }
}
