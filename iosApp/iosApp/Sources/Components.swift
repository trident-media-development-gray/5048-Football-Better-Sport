import SwiftUI

/// Circular team badge built from the team's colours + flag.
struct TeamBadge: View {
    let team: Team
    var size: CGFloat = 44

    var body: some View {
        ZStack {
            Circle()
                .fill(LinearGradient(colors: [team.primary, team.secondary],
                                     startPoint: .topLeading, endPoint: .bottomTrailing))
            Circle().stroke(.white.opacity(0.25), lineWidth: size * 0.04)
            Text(team.flag)
                .font(.system(size: size * 0.5))
                .shadow(radius: 1)
        }
        .frame(width: size, height: size)
        .overlay(alignment: .bottomTrailing) {
            Text(team.id)
                .font(.system(size: size * 0.18, weight: .black, design: .rounded))
                .foregroundStyle(.white)
                .padding(.horizontal, size * 0.06)
                .background(Capsule().fill(.black.opacity(0.55)))
                .offset(x: 1, y: 1)
                .opacity(size >= 40 ? 1 : 0)
        }
    }
}

/// Section heading with an accent bar.
struct SectionHeader: View {
    let title: String
    var action: String? = nil
    var onTap: (() -> Void)? = nil

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Capsule().fill(Brand.limeGrad).frame(width: 4, height: 18)
            Text(title)
                .font(.display(19, .bold))
                .foregroundStyle(Brand.textHi)
            Spacer()
            if let action {
                Button(action: { onTap?() }) {
                    Text(action)
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundStyle(Brand.neon)
                }
            }
        }
    }
}

/// Animated stat bar (PAC / SHO / …).
struct StatBar: View {
    let label: String
    let value: Int
    var tint: Color = Brand.neon
    @State private var shown = false

    var body: some View {
        HStack(spacing: 10) {
            Text(label)
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundStyle(Brand.textLo)
                .frame(width: 34, alignment: .leading)
            Text("\(value)")
                .font(.system(size: 13, weight: .heavy, design: .rounded))
                .foregroundStyle(Brand.textHi)
                .frame(width: 26, alignment: .leading)
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Brand.navyLine.opacity(0.6))
                    Capsule()
                        .fill(LinearGradient(colors: [tint.opacity(0.8), tint],
                                             startPoint: .leading, endPoint: .trailing))
                        .frame(width: shown ? geo.size.width * CGFloat(value) / 100 : 0)
                }
            }
            .frame(height: 8)
        }
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.85).delay(0.05)) {
                shown = true
            }
        }
    }
}

/// Small pill used for stage labels, status, etc.
struct Pill: View {
    let text: String
    var fg: Color = Brand.textHi
    var bg: Color = Brand.navyLine

    var body: some View {
        Text(text.uppercased())
            .font(.system(size: 10, weight: .heavy, design: .rounded))
            .tracking(0.5)
            .foregroundStyle(fg)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Capsule().fill(bg))
    }
}

/// Pulsing red LIVE indicator.
struct LiveDot: View {
    var label: String = "LIVE"
    @State private var on = false
    var body: some View {
        HStack(spacing: 5) {
            Circle().fill(Brand.danger)
                .frame(width: 7, height: 7)
                .opacity(on ? 1 : 0.3)
                .animation(.easeInOut(duration: 0.7).repeatForever(autoreverses: true), value: on)
            Text(label)
                .font(.system(size: 10, weight: .heavy, design: .rounded))
                .foregroundStyle(Brand.danger)
        }
        .onAppear { on = true }
    }
}

/// Reusable page background: gradient + subtle imagery.
struct PageBackground: View {
    var body: some View {
        ZStack {
            Brand.page.ignoresSafeArea()
            Image("bg2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .opacity(0.18)
                .blur(radius: 1)
                .ignoresSafeArea()
            LinearGradient(colors: [.clear, Brand.ink],
                           startPoint: .center, endPoint: .bottom)
                .ignoresSafeArea()
        }
    }
}
