import SwiftUI
import UIKit

/// Brand palette pulled from the trophy mockup: deep navy, royal blue,
/// neon lime green, gold and silver on a near-black pitch.
enum Brand {
    static let ink      = Color(hex: 0x05080F)
    static let navy     = Color(hex: 0x0A1330)
    static let navyCard = Color(hex: 0x121F49)
    static let navyLine = Color(hex: 0x24356F)
    static let royal    = Color(hex: 0x1B2E86)
    static let blue     = Color(hex: 0x2A4BD0)
    static let lime     = Color(hex: 0xA3D528)
    static let neon     = Color(hex: 0x63C61A)
    static let gold     = Color(hex: 0xE6B33E)
    static let silver   = Color(hex: 0xCBD5E6)
    static let textHi   = Color.white
    static let textLo   = Color(hex: 0x93A4C6)
    static let danger   = Color(hex: 0xE2453B)

    static var page: LinearGradient {
        LinearGradient(colors: [Color(hex: 0x0B1738), Color(hex: 0x05080F)],
                       startPoint: .top, endPoint: .bottom)
    }
    static var limeGrad: LinearGradient {
        LinearGradient(colors: [lime, neon], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    static var goldGrad: LinearGradient {
        LinearGradient(colors: [Color(hex: 0xF7DC8A), gold, Color(hex: 0xB47F25)],
                       startPoint: .top, endPoint: .bottom)
    }
    static var blueGrad: LinearGradient {
        LinearGradient(colors: [Color(hex: 0x2746C2), Color(hex: 0x0E1C57)],
                       startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    static var cardGrad: LinearGradient {
        LinearGradient(colors: [Color(hex: 0x142255), Color(hex: 0x0C1736)],
                       startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

extension Color {
    init(hex: UInt32) {
        let r = Double((hex >> 16) & 0xFF) / 255
        let g = Double((hex >> 8) & 0xFF) / 255
        let b = Double(hex & 0xFF) / 255
        self.init(.sRGB, red: r, green: g, blue: b, opacity: 1)
    }
}

extension Font {
    static func display(_ size: CGFloat, _ weight: Font.Weight = .heavy) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }
}

/// Soft card surface used across the app.
struct CardSurface: ViewModifier {
    var radius: CGFloat = 22
    func body(content: Content) -> some View {
        content
            .background(Brand.cardGrad)
            .overlay(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .stroke(Brand.navyLine.opacity(0.7), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
    }
}

extension View {
    func cardSurface(_ radius: CGFloat = 22) -> some View {
        modifier(CardSurface(radius: radius))
    }

    func neonGlow(_ color: Color = Brand.neon, radius: CGFloat = 14) -> some View {
        shadow(color: color.opacity(0.55), radius: radius, x: 0, y: 0)
    }
}

/// Lightweight haptics helper.
enum Haptics {
    static func tap(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
    static func success() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    static func goal() {
        let g = UIImpactFeedbackGenerator(style: .heavy)
        g.impactOccurred(intensity: 1.0)
    }
}
