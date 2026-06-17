import SwiftUI

/// Persists fan points and tracks predictions + favourite players.
/// Levelling logic is delegated to `FanProgression`.
final class FanStore: ObservableObject {
    @Published var points: Int { didSet { UserDefaults.standard.set(points, forKey: Self.key) } }
    @Published var predictions: [UUID: Outcome] = [:]
    @Published var favourites: Set<UUID> = []
    /// Pro Shop bag — kit items the fan has added. Adding is a toggle, so an
    /// item can't be added twice; the cabinet surfaces the running count.
    @Published var bag: Set<UUID> = []

    private static let key = "fanPoints"
    private let progression: FanProgression

    init(progression: FanProgression) {
        self.progression = progression
        points = UserDefaults.standard.integer(forKey: Self.key)
    }

    // MARK: Actions

    func predict(_ fixture: Fixture, _ outcome: Outcome) {
        let isFirst = predictions[fixture.id] == nil
        predictions[fixture.id] = outcome
        if isFirst { points += 15; Haptics.success() } else { Haptics.tap() }
    }

    func isFavourite(_ player: Player) -> Bool { favourites.contains(player.id) }

    func toggleFavourite(_ player: Player) {
        if favourites.contains(player.id) {
            favourites.remove(player.id)
        } else {
            favourites.insert(player.id)
            points += 5
        }
        Haptics.tap()
    }

    // MARK: Bag

    var bagCount: Int { bag.count }

    func isInBag(_ item: KitItem) -> Bool { bag.contains(item.id) }

    func toggleBag(_ item: KitItem) {
        if bag.contains(item.id) {
            bag.remove(item.id)
            Haptics.tap()
        } else {
            bag.insert(item.id)
            Haptics.success()
        }
    }

    // MARK: Derived level state

    var level: FanLevel { progression.level(for: points) }
    var nextThreshold: Int { progression.nextThreshold(for: points) }
    var levelProgress: Double { progression.progress(for: points) }
}
