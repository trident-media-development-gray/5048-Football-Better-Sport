import SwiftUI

final class SquadViewModel: ObservableObject {
    @Published var filter: Position? = nil {
        didSet { recompute() }
    }
    @Published private(set) var players: [Player] = []

    private let repository: SquadRepository

    init(env: AppEnvironment = .shared) {
        self.repository = env.squadRepository
        recompute()
    }

    let positions = Position.allCases

    private func recompute() {
        players = repository.players(in: filter).sorted {
            ($0.position.order, -$0.rating) < ($1.position.order, -$1.rating)
        }
    }

    func select(_ position: Position?) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) { filter = position }
        Haptics.tap()
    }
}
