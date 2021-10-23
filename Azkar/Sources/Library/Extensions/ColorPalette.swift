//
//  ColorPalette.swift
//  Azkar
//
//  Created by Al Jawziyya on 06.04.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import SwiftUI

extension Color {
    static var palette: [Color] = [
        "cabbe9", "ffcef3", "a1eafb", "769fcd", "b693fe"
        ].compactMap { Color(hex: $0) }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension Color {
    
    private static func getColor(_ name: String = #function) -> Color {
        if let color = UIColor(named: colorTheme.colorsNamespacePrefix + name) {
            return Color(color)
        } else {
            return Color(name)
        }
    }

    static var accent: Color {
        getColor()
    }

    static var liteAccent: Color {
        getColor()
    }
    
    static var text: Color {
        getColor()
    }
    
    static var secondaryText: Color {
        getColor()
    }

    static var tertiaryText: Color {
        getColor()
    }

    static var background: Color {
        getColor()
    }
    
    static var contentBackground: Color {
        getColor()
    }

    static var secondaryBackground: Color {
        getColor()
    }

    static var dimmedBackground: Color {
        getColor()
    }
    
}
