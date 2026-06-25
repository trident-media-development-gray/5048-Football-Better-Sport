import SwiftUI
import UIKit

enum Tab: Int, CaseIterable {
    case hub, table, squad, news, history, cabinet

    var titleKey: LKey {
        switch self {
        case .hub:     return .tabHub
        case .table:   return .tabGroup
        case .squad:   return .tabSquad
        case .news:    return .tabNews
        case .history: return .tabHistory
        case .cabinet: return .tabCabinet
        }
    }
    var icon: String {
        switch self {
        case .hub:     return "sportscourt.fill"
        case .table:   return "list.number"
        case .squad:   return "person.3.fill"
        case .news:    return "newspaper.fill"
        case .history: return "books.vertical.fill"
        case .cabinet: return "trophy.fill"
        }
    }
}

struct RootView: View {
    @EnvironmentObject var loc: LocalizationManager
    @State private var tab: Tab = .hub
    @State private var showSettings = false

    init() {
        UITabBar.appearance().isHidden = true
    }

    var body: some View {
        NavigationStack {
            ZStack {
                PageBackground()

                Group {
                    switch tab {
                    case .hub:     HubView()
                    case .table:   TableView()
                    case .squad:   SquadView()
                    case .news:    NewsView()
                    case .history: HistoryView()
                    case .cabinet: CabinetView(showSettings: $showSettings)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                // The tab bar lives in the bottom safe-area inset so scroll
                // content reserves space for it and never slides underneath.
                // `spacing` keeps a little breathing room above the bar.
                .safeAreaInset(edge: .bottom, spacing: 8) {
                    CustomTabBar(tab: $tab)
                }
            }
            .navigationDestination(for: Player.self) { player in
                PlayerDetailView(player: player)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .tint(Brand.neon)
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
}

struct CustomTabBar: View {
    @Binding var tab: Tab
    @EnvironmentObject var loc: LocalizationManager
    @Namespace private var ns

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.self) { item in
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) { tab = item }
                    Haptics.tap()
                } label: {
                    VStack(spacing: 4) {
                        ZStack {
                            if tab == item {
                                Capsule().fill(Brand.limeGrad)
                                    .matchedGeometryEffect(id: "tab", in: ns)
                                    .frame(width: 42, height: 30)
                            }
                            Image(systemName: item.icon)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundStyle(tab == item ? Brand.ink : Brand.textLo)
                        }
                        .frame(height: 30)
                        Text(loc.t(item.titleKey))
                            .font(.system(size: 9.5, weight: .heavy, design: .rounded))
                            .foregroundStyle(tab == item ? Brand.neon : Brand.textLo)
                            .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 8)
        .padding(.top, 10)
        .padding(.bottom, 4)
        .background(
            .ultraThinMaterial.opacity(0.9),
            in: RoundedRectangle(cornerRadius: 26, style: .continuous)
        )
        .overlay(RoundedRectangle(cornerRadius: 26, style: .continuous)
            .stroke(Brand.navyLine, lineWidth: 1))
        .padding(.horizontal, 14)
        .padding(.bottom, 6)
        // Keep the bar aligned with the centred content column on iPad
        // instead of stretching across the full width of the screen.
        .readableWidth()
    }
}
