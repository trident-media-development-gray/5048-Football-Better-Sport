import SwiftUI

final class TableViewModel: ObservableObject {
    @Published private(set) var standings: [StandingRow]
    @Published private(set) var fixtures: [Fixture]
    let qualifyingSpots = 2

    init(env: AppEnvironment = .shared) {
        let teams = env.teamRepository.groupTeams()
        let allFixtures = env.fixtureRepository.all()
        self.standings = env.standingsCalculator.standings(for: teams, from: allFixtures)
        self.fixtures = allFixtures
    }

    func qualifies(rank: Int) -> Bool { rank <= qualifyingSpots }
}
