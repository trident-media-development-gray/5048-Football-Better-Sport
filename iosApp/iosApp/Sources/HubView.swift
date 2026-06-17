import SwiftUI

struct HubView: View {
    @EnvironmentObject var loc: LocalizationManager
    @StateObject private var model = HubViewModel()

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 22) {
                header
                LiveMatchCard(simulator: model.simulator)
                predictions
                starsCarousel
            }
            .padding(.horizontal, 18)
            .padding(.top, 8)
        }
    }

    private var header: some View {
        HStack(spacing: 12) {
            Image("crest")
                .resizable().scaledToFit()
                .frame(width: 46, height: 46)
                .neonGlow(Brand.blue, radius: 10)
            VStack(alignment: .leading, spacing: 1) {
                Text(loc.t(.appName).uppercased())
                    .font(.display(22, .black))
                    .foregroundStyle(Brand.textHi)
                Text(loc.f(.headerSubtitle, model.matchday))
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundStyle(Brand.textLo)
            }
            Spacer()
            LanguageToggle()
            FanChip()
        }
    }

    private var predictions: some View {
        VStack(spacing: 12) {
            SectionHeader(title: loc.t(.predictEarn))
            ForEach(model.upcoming) { fx in
                PredictionRow(fixture: fx)
            }
        }
    }

    private var starsCarousel: some View {
        VStack(spacing: 12) {
            SectionHeader(title: loc.t(.starMen))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(model.stars) { player in
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

// MARK: - Header controls

struct LanguageToggle: View {
    @EnvironmentObject var loc: LocalizationManager
    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) { loc.toggleLanguage() }
        } label: {
            HStack(spacing: 5) {
                Text(currentFlag).font(.system(size: 15))
                Text(loc.language.rawValue.prefix(2).uppercased())
                    .font(.system(size: 12, weight: .black, design: .rounded))
                    .foregroundStyle(Brand.textHi)
            }
            .padding(.horizontal, 10).padding(.vertical, 7)
            .background(Capsule().fill(Brand.navyCard))
            .overlay(Capsule().stroke(Brand.navyLine, lineWidth: 1))
        }
        .buttonStyle(PressStyle())
    }
    private var currentFlag: String { loc.language.flag }
}

struct FanChip: View {
    @EnvironmentObject var fan: FanStore
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "bolt.fill").font(.system(size: 12, weight: .black))
            Text("\(fan.points)")
                .font(.system(size: 15, weight: .black, design: .rounded))
                .contentTransition(.numericText())
        }
        .foregroundStyle(Brand.ink)
        .padding(.horizontal, 12).padding(.vertical, 7)
        .background(Capsule().fill(Brand.limeGrad))
        .neonGlow(Brand.neon, radius: 8)
    }
}

// MARK: - Live match simulator card

struct LiveMatchCard: View {
    @ObservedObject var simulator: MatchSimulator
    @EnvironmentObject var loc: LocalizationManager

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Pill(text: loc.t(.featured), fg: Brand.neon, bg: Brand.navyLine)
                Spacer()
                if simulator.isRunning {
                    LiveDot(label: loc.t(.live))
                } else {
                    Text(statusLabel.uppercased())
                        .font(.system(size: 10, weight: .heavy, design: .rounded))
                        .foregroundStyle(Brand.textLo)
                }
            }

            HStack(alignment: .center) {
                teamColumn(simulator.home)
                VStack(spacing: 4) {
                    Text("\(simulator.homeScore)–\(simulator.awayScore)")
                        .font(.system(size: 44, weight: .black, design: .rounded))
                        .foregroundStyle(Brand.textHi)
                        .contentTransition(.numericText())
                        .monospacedDigit()
                    Text(clockLabel)
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundStyle(simulator.isRunning ? Brand.neon : Brand.textLo)
                }
                .frame(maxWidth: .infinity)
                teamColumn(simulator.away)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Brand.navyLine.opacity(0.5))
                    Capsule().fill(Brand.limeGrad)
                        .frame(width: geo.size.width * CGFloat(simulator.minute) / 90)
                }
            }
            .frame(height: 6)
            .animation(.linear(duration: 0.28), value: simulator.minute)

            controlButton

            if !simulator.events.isEmpty {
                VStack(spacing: 8) {
                    ForEach(simulator.events.prefix(4)) { ev in
                        EventRow(event: ev)
                    }
                }
                .transition(.opacity)
            }
        }
        .padding(18)
        .background(
            ZStack {
                Brand.cardGrad
                Image("bg1").resizable().scaledToFill().opacity(0.10)
            }
        )
        .overlay(RoundedRectangle(cornerRadius: 26, style: .continuous)
            .stroke(Brand.navyLine, lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        .neonGlow(Brand.royal.opacity(0.8), radius: 18)
    }

    private func teamColumn(_ team: Team) -> some View {
        VStack(spacing: 8) {
            TeamBadge(team: team, size: 60).neonGlow(team.primary.opacity(0.6), radius: 10)
            Text(loc.teamName(team))
                .font(.system(size: 14, weight: .heavy, design: .rounded))
                .foregroundStyle(Brand.textHi)
        }
        .frame(maxWidth: .infinity)
    }

    private var controlButton: some View {
        Button { simulator.toggle() } label: {
            HStack(spacing: 8) {
                Image(systemName: buttonIcon)
                Text(buttonTitle)
            }
            .font(.system(size: 16, weight: .black, design: .rounded))
            .foregroundStyle(Brand.ink)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Capsule().fill(Brand.limeGrad))
            .neonGlow(Brand.neon, radius: 10)
        }
        .buttonStyle(PressStyle())
    }

    private var clockLabel: String {
        switch simulator.phase {
        case .pregame:  return loc.t(.tapKickOff)
        case .running:  return "\(simulator.minute)'"
        case .paused:   return "\(loc.t(.paused)) · \(simulator.minute)'"
        case .finished: return loc.t(.fullTime)
        }
    }
    private var statusLabel: String {
        simulator.phase == .finished ? loc.t(.fullTime) : clockLabel
    }
    private var buttonIcon: String {
        if simulator.isFinished { return "arrow.counterclockwise" }
        return simulator.isRunning ? "pause.fill" : "play.fill"
    }
    private var buttonTitle: String {
        switch simulator.phase {
        case .finished: return loc.t(.playAgain)
        case .running:  return loc.t(.pause)
        case .paused:   return loc.t(.resume)
        case .pregame:  return loc.t(.kickOff)
        }
    }
}

struct EventRow: View {
    let event: MatchEvent
    @EnvironmentObject var loc: LocalizationManager

    var body: some View {
        HStack(spacing: 10) {
            Text("\(event.minute)'")
                .font(.system(size: 12, weight: .heavy, design: .rounded))
                .foregroundStyle(Brand.textLo)
                .frame(width: 30, alignment: .leading)
            Image(systemName: event.kind.icon)
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(event.kind.tint)
                .frame(width: 18)
            Text(event.text(loc))
                .font(.system(size: 12.5, weight: .medium, design: .rounded))
                .foregroundStyle(Brand.textHi)
                .lineLimit(1)
            Spacer(minLength: 0)
        }
        .padding(.vertical, 7).padding(.horizontal, 10)
        .background(RoundedRectangle(cornerRadius: 10).fill(Brand.navy.opacity(0.6)))
    }
}

// MARK: - Prediction row

struct PredictionRow: View {
    let fixture: Fixture
    @EnvironmentObject var loc: LocalizationManager
    @EnvironmentObject var fan: FanStore

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Pill(text: loc.stage(fixture), bg: Brand.navy)
                Spacer()
                Text(loc.kickoffLabel(fixture))
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundStyle(Brand.textLo)
            }
            HStack {
                matchSide(fixture.home)
                Text(loc.t(.vs)).font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundStyle(Brand.textLo)
                matchSide(fixture.away)
            }
            HStack(spacing: 8) {
                predictButton(.home, label: fixture.home.id)
                predictButton(.draw, label: loc.t(.draw))
                predictButton(.away, label: fixture.away.id)
            }
        }
        .padding(14)
        .cardSurface(18)
    }

    private func matchSide(_ team: Team) -> some View {
        HStack(spacing: 8) {
            TeamBadge(team: team, size: 30)
            Text(loc.teamName(team))
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(Brand.textHi)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func predictButton(_ outcome: Outcome, label: String) -> some View {
        let selected = fan.predictions[fixture.id] == outcome
        return Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                fan.predict(fixture, outcome)
            }
        } label: {
            Text(label)
                .font(.system(size: 13, weight: .heavy, design: .rounded))
                .foregroundStyle(selected ? Brand.ink : Brand.textHi)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    Capsule().fill(selected ? AnyShapeStyle(Brand.limeGrad)
                                            : AnyShapeStyle(Brand.navy))
                )
                .overlay(Capsule().stroke(Brand.navyLine, lineWidth: selected ? 0 : 1))
        }
        .buttonStyle(PressStyle())
    }
}

// MARK: - Star card

struct StarCard: View {
    let player: Player
    @EnvironmentObject var loc: LocalizationManager

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topLeading) {
                LinearGradient(colors: [Brand.royal, Brand.navy],
                               startPoint: .top, endPoint: .bottom)
                if let photo = player.photo {
                    Image(photo).resizable().scaledToFit()
                        .frame(maxWidth: .infinity)
                        .padding(.top, 8)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(player.rating)")
                        .font(.system(size: 22, weight: .black, design: .rounded))
                        .foregroundStyle(Brand.gold)
                    Text(player.position.rawValue)
                        .font(.system(size: 11, weight: .heavy, design: .rounded))
                        .foregroundStyle(Brand.textHi)
                }
                .padding(10)
            }
            .frame(width: 150, height: 170)
            .clipped()

            VStack(alignment: .leading, spacing: 2) {
                Text(player.name)
                    .font(.system(size: 14, weight: .heavy, design: .rounded))
                    .foregroundStyle(Brand.textHi)
                    .lineLimit(1)
                Text("\(player.goals) G · \(player.assists) A")
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundStyle(Brand.neon)
            }
            .frame(width: 150, alignment: .leading)
            .padding(10)
        }
        .background(Brand.cardGrad)
        .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous)
            .stroke(Brand.navyLine, lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

struct PressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}
