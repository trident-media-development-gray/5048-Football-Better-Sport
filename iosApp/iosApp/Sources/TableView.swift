import SwiftUI

struct TableView: View {
    @EnvironmentObject var loc: LocalizationManager
    @StateObject private var model = TableViewModel()

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 18) {
                groupCard
                resultsCard
            }
            .padding(.horizontal, 18)
            .padding(.top, 8)
            .readableWidth()
        }
    }

    private var groupCard: some View {
        VStack(spacing: 14) {
            HStack {
                Text(loc.t(.groupDTitle))
                    .font(.display(24, .black))
                    .foregroundStyle(Brand.textHi)
                Spacer()
                Pill(text: loc.t(.topTwoAdvance), fg: Brand.neon, bg: Brand.navy)
            }
            HStack(spacing: 0) {
                Text("#").frame(width: 22, alignment: .leading)
                Text(loc.t(.colTeam)).frame(maxWidth: .infinity, alignment: .leading)
                ForEach(["P", "GD", "PTS"], id: \.self) { h in
                    Text(h).frame(width: h == "PTS" ? 38 : 30)
                }
                Text(loc.t(.colForm)).frame(width: 70, alignment: .trailing)
            }
            .font(.system(size: 11, weight: .heavy, design: .rounded))
            .foregroundStyle(Brand.textLo)

            ForEach(Array(model.standings.enumerated()), id: \.element.id) { idx, row in
                StandingRowView(rank: idx + 1, row: row, qualifies: model.qualifies(rank: idx + 1))
            }
        }
        .padding(16)
        .cardSurface()
    }

    private var resultsCard: some View {
        VStack(spacing: 12) {
            SectionHeader(title: loc.t(.resultsFixtures))
            ForEach(model.fixtures) { fx in
                FixtureRow(fixture: fx)
            }
        }
    }
}

struct StandingRowView: View {
    let rank: Int
    let row: StandingRow
    let qualifies: Bool
    @EnvironmentObject var loc: LocalizationManager

    var body: some View {
        HStack(spacing: 0) {
            Capsule()
                .fill(qualifies ? AnyShapeStyle(Brand.limeGrad) : AnyShapeStyle(Brand.navyLine))
                .frame(width: 4, height: 24)
                .frame(width: 22, alignment: .leading)

            HStack(spacing: 10) {
                Text("\(rank)")
                    .font(.system(size: 14, weight: .black, design: .rounded))
                    .foregroundStyle(qualifies ? Brand.neon : Brand.textLo)
                    .frame(width: 14)
                TeamBadge(team: row.team, size: 30)
                Text(loc.teamName(row.team))
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(Brand.textHi)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Group {
                Text("\(row.played)").frame(width: 30)
                Text(row.gd > 0 ? "+\(row.gd)" : "\(row.gd)").frame(width: 30)
                Text("\(row.points)")
                    .foregroundStyle(Brand.gold)
                    .frame(width: 38)
            }
            .font(.system(size: 13, weight: .heavy, design: .rounded))
            .foregroundStyle(Brand.textHi)

            HStack(spacing: 4) {
                ForEach(Array(row.form.enumerated()), id: \.offset) { _, c in
                    FormDot(result: c)
                }
            }
            .frame(width: 70, alignment: .trailing)
        }
        .padding(.vertical, 6)
    }
}

struct FormDot: View {
    let result: Character
    private var color: Color {
        switch result {
        case "W": return Brand.neon
        case "D": return Brand.gold
        default:  return Brand.danger
        }
    }
    var body: some View {
        Text(String(result))
            .font(.system(size: 10, weight: .black, design: .rounded))
            .foregroundStyle(Brand.ink)
            .frame(width: 18, height: 18)
            .background(Circle().fill(color))
    }
}

struct FixtureRow: View {
    let fixture: Fixture
    @EnvironmentObject var loc: LocalizationManager

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                teamLine(fixture.home, score: fixture.homeScore)
                teamLine(fixture.away, score: fixture.awayScore)
            }
            Spacer()
            VStack(spacing: 4) {
                if fixture.status == .live {
                    LiveDot(label: loc.t(.live))
                    Text("\(fixture.liveMinute)'")
                        .font(.system(size: 12, weight: .heavy, design: .rounded))
                        .foregroundStyle(Brand.danger)
                } else {
                    Text(loc.kickoffLabel(fixture))
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundStyle(fixture.status == .finished ? Brand.textLo : Brand.neon)
                    Text(loc.stage(fixture))
                        .font(.system(size: 9, weight: .semibold, design: .rounded))
                        .foregroundStyle(Brand.textLo)
                }
            }
        }
        .padding(14)
        .cardSurface(16)
    }

    private func teamLine(_ team: Team, score: Int) -> some View {
        HStack(spacing: 10) {
            TeamBadge(team: team, size: 26)
            Text(loc.teamName(team))
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundStyle(Brand.textHi)
            if fixture.status != .upcoming {
                Spacer(minLength: 8)
                Text("\(score)")
                    .font(.system(size: 16, weight: .black, design: .rounded))
                    .foregroundStyle(Brand.textHi)
            }
        }
    }
}
