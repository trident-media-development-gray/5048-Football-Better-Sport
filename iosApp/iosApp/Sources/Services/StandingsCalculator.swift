import Foundation

/// Computes a live league table from raw fixtures, rather than hard-coding it.
final class StandingsCalculator {

    private struct Tally {
        var played = 0, won = 0, drawn = 0, lost = 0, gf = 0, ga = 0
        var form: [Character] = []
    }

    /// Build standings for the given teams from any fixtures that have a score
    /// (finished or live), sorted by points → goal difference → goals scored.
    func standings(for teams: [Team], from fixtures: [Fixture]) -> [StandingRow] {
        var tallies: [String: Tally] = [:]
        teams.forEach { tallies[$0.id] = Tally() }

        for fx in fixtures where fx.status != .upcoming {
            guard tallies[fx.home.id] != nil, tallies[fx.away.id] != nil else { continue }
            apply(fx, isHome: true, into: &tallies)
            apply(fx, isHome: false, into: &tallies)
        }

        let rows = teams.map { team -> StandingRow in
            let t = tallies[team.id] ?? Tally()
            return StandingRow(team: team, played: t.played, won: t.won, drawn: t.drawn,
                               lost: t.lost, gf: t.gf, ga: t.ga, form: t.form)
        }

        return rows.sorted {
            ($0.points, $0.gd, $0.gf) > ($1.points, $1.gd, $1.gf)
        }
    }

    private func apply(_ fx: Fixture, isHome: Bool, into tallies: inout [String: Tally]) {
        let id = isHome ? fx.home.id : fx.away.id
        let forSelf = isHome ? fx.homeScore : fx.awayScore
        let against = isHome ? fx.awayScore : fx.homeScore
        guard var t = tallies[id] else { return }

        t.played += 1
        t.gf += forSelf
        t.ga += against
        if forSelf > against {
            t.won += 1; t.form.append("W")
        } else if forSelf == against {
            t.drawn += 1; t.form.append("D")
        } else {
            t.lost += 1; t.form.append("L")
        }
        tallies[id] = t
    }
}
