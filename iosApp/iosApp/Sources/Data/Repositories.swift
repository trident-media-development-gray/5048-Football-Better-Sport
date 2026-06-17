import Foundation

// MARK: - Repository protocols

protocol TeamRepository {
    func groupTeams() -> [Team]
}

protocol SquadRepository {
    func allPlayers() -> [Player]
    func stars() -> [Player]
    func players(in position: Position?) -> [Player]
}

protocol FixtureRepository {
    func featured() -> Fixture
    func all() -> [Fixture]
    func upcoming() -> [Fixture]
}

protocol LegendRepository {
    func all() -> [Legend]
}

protocol HistoryRepository {
    func timeline() -> [HistoryEvent]
}

protocol TrophyRepository {
    func all() -> [Trophy]
}

protocol KitRepository {
    func all() -> [KitItem]
}

// MARK: - In-memory implementations (backed by Catalog)

struct InMemoryTeamRepository: TeamRepository {
    func groupTeams() -> [Team] { Catalog.groupDTeams }
}

struct InMemorySquadRepository: SquadRepository {
    func allPlayers() -> [Player] { Catalog.squad }
    func stars() -> [Player] { Catalog.squad.filter { $0.isStar } }
    func players(in position: Position?) -> [Player] {
        guard let position else { return Catalog.squad }
        return Catalog.squad.filter { $0.position == position }
    }
}

struct InMemoryFixtureRepository: FixtureRepository {
    func featured() -> Fixture { Catalog.featured }
    func all() -> [Fixture] { Catalog.fixtures }
    func upcoming() -> [Fixture] { Catalog.fixtures.filter { $0.status == .upcoming } }
}

struct InMemoryLegendRepository: LegendRepository {
    func all() -> [Legend] { Catalog.legends }
}

struct InMemoryHistoryRepository: HistoryRepository {
    func timeline() -> [HistoryEvent] { Catalog.history }
}

struct InMemoryTrophyRepository: TrophyRepository {
    func all() -> [Trophy] { Catalog.trophies }
}

struct InMemoryKitRepository: KitRepository {
    func all() -> [KitItem] { Catalog.kit }
}
