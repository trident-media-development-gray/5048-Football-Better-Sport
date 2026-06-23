import SwiftUI

struct SquadView: View {
    @EnvironmentObject var loc: LocalizationManager
    @EnvironmentObject var fan: FanStore
    @StateObject private var model = SquadViewModel()
    @State private var favouritesOnly = false
    @Environment(\.horizontalSizeClass) private var sizeClass

    private var columns: [GridItem] { AppLayout.gridColumns(sizeClass) }

    /// Players currently shown — the position-filtered set, narrowed to
    /// favourites when the Favourites category is active.
    private var shownPlayers: [Player] {
        favouritesOnly ? model.players.filter { fan.isFavourite($0) } : model.players
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                filterBar
                if favouritesOnly && shownPlayers.isEmpty {
                    emptyFavourites
                } else {
                    LazyVGrid(columns: columns, spacing: 14) {
                        ForEach(shownPlayers) { player in
                            NavigationLink(value: player) {
                                PlayerTile(player: player)
                            }
                            .buttonStyle(PressStyle())
                        }
                    }
                }
            }
            .padding(.horizontal, 18)
            .padding(.top, 8)
            .readableWidth()
        }
    }

    private var filterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                chip(nil, loc.t(.filterAll))
                favouritesChip
                ForEach(model.positions, id: \.self) { pos in
                    chip(pos, pos.rawValue)
                }
            }
        }
    }

    private func chip(_ pos: Position?, _ label: String) -> some View {
        let selected = !favouritesOnly && model.filter == pos
        return Button {
            favouritesOnly = false
            model.select(pos)
        } label: {
            Text(label)
                .font(.system(size: 13, weight: .heavy, design: .rounded))
                .foregroundStyle(selected ? Brand.ink : Brand.textHi)
                .padding(.horizontal, 16).padding(.vertical, 9)
                .background(Capsule().fill(selected ? AnyShapeStyle(Brand.limeGrad)
                                                    : AnyShapeStyle(Brand.navyCard)))
                .overlay(Capsule().stroke(Brand.navyLine, lineWidth: selected ? 0 : 1))
        }
    }

    private var favouritesChip: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                favouritesOnly = true
                model.filter = nil
            }
            Haptics.tap()
        } label: {
            HStack(spacing: 5) {
                Image(systemName: "star.fill").font(.system(size: 11, weight: .black))
                Text(loc.t(.filterFavourites))
                    .font(.system(size: 13, weight: .heavy, design: .rounded))
            }
            .foregroundStyle(favouritesOnly ? Brand.ink : Brand.gold)
            .padding(.horizontal, 16).padding(.vertical, 9)
            .background(Capsule().fill(favouritesOnly ? AnyShapeStyle(Brand.goldGrad)
                                                      : AnyShapeStyle(Brand.navyCard)))
            .overlay(Capsule().stroke(favouritesOnly ? Color.clear : Brand.navyLine, lineWidth: 1))
        }
    }

    private var emptyFavourites: some View {
        VStack(spacing: 14) {
            Image(systemName: "star.slash")
                .font(.system(size: 46, weight: .regular))
                .foregroundStyle(Brand.textLo)
            Text(loc.t(.noFavourites))
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(Brand.textLo)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 70)
        .padding(.horizontal, 24)
    }
}

struct PlayerTile: View {
    let player: Player
    @EnvironmentObject var fan: FanStore

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .top) {
                LinearGradient(colors: [player.position.tint.opacity(0.5), Brand.navy],
                               startPoint: .top, endPoint: .bottom)
                Group {
                    if let photo = player.photo {
                        Image(photo).resizable().scaledToFit().padding(.top, 6)
                    } else {
                        Image(systemName: "figure.soccer")
                            .font(.system(size: 64, weight: .regular))
                            .foregroundStyle(Brand.textHi.opacity(0.5))
                            .padding(.top, 30)
                    }
                }
                .frame(maxWidth: .infinity)

                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(player.rating)")
                            .font(.system(size: 24, weight: .black, design: .rounded))
                            .foregroundStyle(Brand.gold)
                        Text(player.position.rawValue)
                            .font(.system(size: 10, weight: .heavy, design: .rounded))
                            .foregroundStyle(Brand.textHi)
                    }
                    Spacer()
                    if fan.isFavourite(player) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(Brand.gold)
                    }
                }
                .padding(10)
            }
            .frame(height: 150)
            .clipped()

            HStack {
                Text("\(player.number)")
                    .font(.system(size: 13, weight: .black, design: .rounded))
                    .foregroundStyle(Brand.neon)
                Text(player.name)
                    .font(.system(size: 13, weight: .heavy, design: .rounded))
                    .foregroundStyle(Brand.textHi)
                    .lineLimit(1)
                Spacer(minLength: 0)
            }
            .padding(10)
        }
        .background(Brand.cardGrad)
        .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous)
            .stroke(Brand.navyLine, lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

// MARK: - Player detail

struct PlayerDetailView: View {
    let player: Player
    @EnvironmentObject var loc: LocalizationManager
    @EnvironmentObject var fan: FanStore

    private var isFav: Bool { fan.isFavourite(player) }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 18) {
                hero
                ratingsCard
                seasonCard
                Color.clear.frame(height: 24)
            }
            .padding(.horizontal, 18)
            .readableWidth()
        }
        .background(PageBackground())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(loc.nickname(player))
                    .font(.display(17, .bold))
                    .foregroundStyle(Brand.textHi)
            }
        }
    }

    private var hero: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(colors: [Brand.royal, Brand.navy],
                           startPoint: .top, endPoint: .bottom)
            Image("bg3").resizable().scaledToFill().opacity(0.25)

            if let photo = player.photo {
                // Fit the whole figure within a bounded height so the player's
                // head is always visible and never cropped at the top.
                Image(photo).resizable().scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 300, alignment: .top)
                    .padding(.top, 14)
            } else {
                Image(systemName: "figure.soccer")
                    .font(.system(size: 130))
                    .foregroundStyle(Brand.textHi.opacity(0.4))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
            }

            // Scrim keeps the name plate legible over the photo.
            LinearGradient(colors: [.clear, Brand.ink.opacity(0.9)],
                           startPoint: .center, endPoint: .bottom)
        }
        .frame(height: 340)
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        .overlay(alignment: .bottomLeading) {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Pill(text: loc.positionLong(player.position), fg: Brand.ink, bg: player.position.tint)
                    Pill(text: "#\(player.number)", fg: Brand.textHi, bg: Brand.navy)
                }
                Text(player.name)
                    .font(.display(28, .black))
                    .foregroundStyle(Brand.textHi)
                HStack(spacing: 6) {
                    Text(loc.t(.ovr))
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundStyle(Brand.textLo)
                    Text("\(player.rating)")
                        .font(.system(size: 22, weight: .black, design: .rounded))
                        .foregroundStyle(Brand.gold)
                }
            }
            .padding(18)
        }
        .overlay(alignment: .topTrailing) {
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    fan.toggleFavourite(player)
                }
            } label: {
                Image(systemName: isFav ? "star.fill" : "star")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(isFav ? Brand.ink : Brand.textHi)
                    .padding(12)
                    .background(Circle().fill(isFav ? AnyShapeStyle(Brand.goldGrad)
                                                    : AnyShapeStyle(.black.opacity(0.35))))
            }
            .padding(14)
        }
    }

    private var ratingsCard: some View {
        VStack(spacing: 14) {
            SectionHeader(title: loc.t(.attributes))
            ForEach(player.attributes, id: \.0) { stat in
                StatBar(label: stat.0, value: stat.1, tint: player.position.tint)
            }
        }
        .padding(16)
        .cardSurface()
    }

    private var seasonCard: some View {
        VStack(spacing: 14) {
            SectionHeader(title: loc.t(.season))
            HStack(spacing: 12) {
                statBox("\(player.goals)", loc.t(.statGoals), Brand.neon)
                statBox("\(player.assists)", loc.t(.statAssists), Brand.blue)
                statBox("\(player.caps)", loc.t(.statCaps), Brand.gold)
            }
        }
        .padding(16)
        .cardSurface()
    }

    private func statBox(_ value: String, _ label: String, _ tint: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 26, weight: .black, design: .rounded))
                .foregroundStyle(tint)
            Text(label.uppercased())
                .font(.system(size: 10, weight: .heavy, design: .rounded))
                .foregroundStyle(Brand.textLo)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(RoundedRectangle(cornerRadius: 14).fill(Brand.navy.opacity(0.6)))
    }
}
