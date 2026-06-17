import SwiftUI

final class HubViewModel: ObservableObject {
    @Published private(set) var upcoming: [Fixture]
    @Published private(set) var stars: [Player]
    let simulator: MatchSimulator
    let matchday: Int

    init(env: AppEnvironment = .shared) {
        let featured = env.fixtureRepository.featured()
        self.simulator = MatchSimulator(home: featured.home, away: featured.away)
        self.matchday = featured.matchday
        self.upcoming = env.fixtureRepository.upcoming()
        self.stars = env.squadRepository.stars()
    }
}
