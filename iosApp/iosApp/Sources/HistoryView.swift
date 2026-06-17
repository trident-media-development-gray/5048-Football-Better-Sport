import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var loc: LocalizationManager
    @StateObject private var model = HistoryViewModel()
    @State private var selectedLegend: Legend? = nil

    private let columns = [GridItem(.flexible(), spacing: 14),
                           GridItem(.flexible(), spacing: 14)]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 22) {
                hero
                timeline
                legends
                currentStars
            }
            .padding(.horizontal, 18)
            .padding(.top, 8)
        }
        .sheet(item: $selectedLegend) { legend in
            LegendDetailSheet(legend: legend)
                .presentationDetents([.medium, .large])
        }
    }

    // MARK: Hero

    private var hero: some View {
        ZStack(alignment: .bottomLeading) {
            Image("flag_brazil").resizable().scaledToFill()
                .frame(height: 190)
                .clipped()
            LinearGradient(colors: [.clear, Brand.ink.opacity(0.95)],
                           startPoint: .top, endPoint: .bottom)
            VStack(alignment: .leading, spacing: 6) {
                Pill(text: "1914 — \(loc.t(.appName))", fg: Brand.gold, bg: .black.opacity(0.4))
                Text(loc.t(.historyTitle))
                    .font(.display(30, .black))
                    .foregroundStyle(Brand.textHi)
                Text(loc.t(.historyBlurb))
                    .font(.system(size: 12.5, weight: .medium, design: .rounded))
                    .foregroundStyle(Brand.textHi.opacity(0.85))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(16)
        }
        .frame(height: 190)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 24, style: .continuous)
            .stroke(Brand.gold.opacity(0.4), lineWidth: 1))
    }

    // MARK: Timeline

    private var timeline: some View {
        VStack(spacing: 12) {
            SectionHeader(title: loc.t(.timelineTitle))
            VStack(spacing: 0) {
                ForEach(Array(model.timeline.enumerated()), id: \.element.id) { idx, event in
                    TimelineRow(event: event, isLast: idx == model.timeline.count - 1)
                }
            }
            .padding(16)
            .cardSurface()
        }
    }

    // MARK: Legends

    private var legends: some View {
        VStack(spacing: 12) {
            SectionHeader(title: loc.t(.legendsTitle))
            Text(loc.t(.legendsSub))
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(Brand.textLo)
                .frame(maxWidth: .infinity, alignment: .leading)
            LazyVGrid(columns: columns, spacing: 14) {
                ForEach(model.legends) { legend in
                    Button {
                        Haptics.tap()
                        selectedLegend = legend
                    } label: {
                        LegendCard(legend: legend)
                    }
                    .buttonStyle(PressStyle())
                }
            }
        }
    }

    // MARK: Current stars link

    private var currentStars: some View {
        VStack(spacing: 12) {
            SectionHeader(title: loc.t(.currentStarsTitle))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(model.currentStars) { player in
                        NavigationLink(value: player) {
                            StarCard(player: player)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 2)
            }
        }
    }
}

// MARK: - Timeline row

struct TimelineRow: View {
    let event: HistoryEvent
    let isLast: Bool
    @EnvironmentObject var loc: LocalizationManager

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .fill(event.isTriumph ? AnyShapeStyle(Brand.goldGrad)
                                              : AnyShapeStyle(Brand.navyLine))
                        .frame(width: 26, height: 26)
                    Image(systemName: event.isTriumph ? "star.fill" : "circle.fill")
                        .font(.system(size: event.isTriumph ? 11 : 6, weight: .black))
                        .foregroundStyle(event.isTriumph ? Brand.ink : Brand.textLo)
                }
                if !isLast {
                    Rectangle().fill(Brand.navyLine)
                        .frame(width: 2)
                        .frame(maxHeight: .infinity)
                }
            }
            .frame(width: 26)

            VStack(alignment: .leading, spacing: 3) {
                Text(loc.historyTitle(event))
                    .font(.system(size: 14, weight: .heavy, design: .rounded))
                    .foregroundStyle(event.isTriumph ? Brand.gold : Brand.textHi)
                Text(loc.historyDetail(event))
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(Brand.textLo)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.bottom, isLast ? 0 : 18)
            Spacer(minLength: 0)
        }
    }
}

// MARK: - Legend card

struct LegendCard: View {
    let legend: Legend
    @EnvironmentObject var loc: LocalizationManager

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .bottomLeading) {
                LinearGradient(colors: [legend.accent.opacity(0.55), Brand.navy],
                               startPoint: .topTrailing, endPoint: .bottomLeading)
                LegendMonogram(legend: legend)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 14)
                Pill(text: legend.position.rawValue, fg: Brand.ink, bg: legend.accent)
                    .padding(10)
            }
            .frame(height: 120)
            .clipped()

            VStack(alignment: .leading, spacing: 2) {
                Text(legend.name)
                    .font(.system(size: 15, weight: .black, design: .rounded))
                    .foregroundStyle(Brand.textHi)
                    .lineLimit(1)
                Text(loc.legendNickname(legend))
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundStyle(legend.accent)
                    .lineLimit(1)
                Text(legend.era)
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                    .foregroundStyle(Brand.textLo)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(10)
        }
        .background(Brand.cardGrad)
        .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous)
            .stroke(legend.accent.opacity(0.35), lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

/// Gold monogram medallion used as a stand-in portrait for legends.
struct LegendMonogram: View {
    let legend: Legend
    private var initials: String {
        let parts = legend.name.split(separator: " ")
        let first = parts.first?.first.map(String.init) ?? ""
        let last = parts.count > 1 ? (parts.last?.first.map(String.init) ?? "") : ""
        return (first + last).uppercased()
    }
    var body: some View {
        ZStack {
            Circle().fill(Brand.goldGrad).neonGlow(legend.accent, radius: 10)
            Circle().stroke(.white.opacity(0.3), lineWidth: 2).padding(4)
            Text(initials)
                .font(.system(size: 26, weight: .black, design: .rounded))
                .foregroundStyle(Brand.ink)
        }
        .frame(width: 74, height: 74)
    }
}

// MARK: - Legend detail sheet

struct LegendDetailSheet: View {
    let legend: Legend
    @EnvironmentObject var loc: LocalizationManager

    var body: some View {
        ZStack {
            Brand.page.ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    Capsule().fill(Brand.navyLine).frame(width: 40, height: 5).padding(.top, 10)
                    LegendMonogram(legend: legend).scaleEffect(1.4).frame(height: 110)
                    VStack(spacing: 4) {
                        Text(legend.name)
                            .font(.display(26, .black))
                            .foregroundStyle(Brand.textHi)
                        Text(loc.legendNickname(legend))
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundStyle(legend.accent)
                        Text(legend.era)
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .foregroundStyle(Brand.textLo)
                    }

                    HStack(spacing: 12) {
                        statBox("\(legend.caps)", loc.t(.capsLabel))
                        statBox("\(legend.goals)", loc.t(.goalsLabel))
                        statBox(legend.era, loc.t(.eraLabel))
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Pill(text: loc.t(.honoursTitle), fg: Brand.ink, bg: Brand.gold)
                        Text(loc.legendHonour(legend))
                            .font(.system(size: 14, weight: .heavy, design: .rounded))
                            .foregroundStyle(Brand.gold)
                        Text(loc.legendBio(legend))
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundStyle(Brand.textHi.opacity(0.9))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .cardSurface()
                    Color.clear.frame(height: 20)
                }
                .padding(.horizontal, 20)
            }
        }
    }

    private func statBox(_ value: String, _ label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 22, weight: .black, design: .rounded))
                .foregroundStyle(Brand.textHi)
                .lineLimit(1).minimumScaleFactor(0.6)
            Text(label.uppercased())
                .font(.system(size: 10, weight: .heavy, design: .rounded))
                .foregroundStyle(Brand.textLo)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(RoundedRectangle(cornerRadius: 14).fill(Brand.navy.opacity(0.6)))
    }
}
