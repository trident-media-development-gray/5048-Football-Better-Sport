import SwiftUI

/// Lightweight dependency-injection container. Wires repositories, services,
/// the localization manager and the fan store, and exposes them to the app.
final class AppEnvironment: ObservableObject {
    let localization: LocalizationManager
    let fanStore: FanStore
    let fanProgression: FanProgression
    let profileStore: ProfileStore
    let newsService: NewsService

    let teamRepository: TeamRepository
    let squadRepository: SquadRepository
    let fixtureRepository: FixtureRepository
    let legendRepository: LegendRepository
    let historyRepository: HistoryRepository
    let trophyRepository: TrophyRepository
    let kitRepository: KitRepository

    let standingsCalculator: StandingsCalculator

    init(localization: LocalizationManager,
         fanStore: FanStore,
         fanProgression: FanProgression,
         profileStore: ProfileStore,
         newsService: NewsService,
         teamRepository: TeamRepository,
         squadRepository: SquadRepository,
         fixtureRepository: FixtureRepository,
         legendRepository: LegendRepository,
         historyRepository: HistoryRepository,
         trophyRepository: TrophyRepository,
         kitRepository: KitRepository,
         standingsCalculator: StandingsCalculator) {
        self.localization = localization
        self.fanStore = fanStore
        self.fanProgression = fanProgression
        self.profileStore = profileStore
        self.newsService = newsService
        self.teamRepository = teamRepository
        self.squadRepository = squadRepository
        self.fixtureRepository = fixtureRepository
        self.legendRepository = legendRepository
        self.historyRepository = historyRepository
        self.trophyRepository = trophyRepository
        self.kitRepository = kitRepository
        self.standingsCalculator = standingsCalculator
    }

    /// The production object graph.
    static func makeDefault() -> AppEnvironment {
        let progression = FanProgression()
        return AppEnvironment(
            localization: LocalizationManager(),
            fanStore: FanStore(progression: progression),
            fanProgression: progression,
            profileStore: ProfileStore(),
            newsService: NewsService(),
            teamRepository: InMemoryTeamRepository(),
            squadRepository: InMemorySquadRepository(),
            fixtureRepository: InMemoryFixtureRepository(),
            legendRepository: InMemoryLegendRepository(),
            historyRepository: InMemoryHistoryRepository(),
            trophyRepository: InMemoryTrophyRepository(),
            kitRepository: InMemoryKitRepository(),
            standingsCalculator: StandingsCalculator()
        )
    }

    /// Shared singleton so view models can resolve dependencies at construction.
    static let shared = makeDefault()
}
